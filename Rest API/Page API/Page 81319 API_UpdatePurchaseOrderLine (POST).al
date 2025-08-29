//T13751-NS
page 81319 API_UpdatePurchaseOrderLine
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiUpdatePurchaseOrderLine';
    DelayedInsert = true;
    EntityName = 'apiUpdatePurchaseOrderLine';
    EntitySetName = 'apiUpdatePurchaseOrderLines';               //Make Sure First Char in Small Letter and don't use any special char or space
    PageType = API;
    MultipleNewLines = true;
    SourceTable = API_PurchLineDetailUpdate;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No")
                {
                    Caption = 'Document No';
                }
                field(lineNo; Rec."Line No")
                {
                    Caption = 'Line No';
                }
                field(qtyToReceive; Rec."Qty. to Receive")
                {
                    Caption = 'Qty. to Receive';
                    DecimalPlaces = 0 : 5;
                }
                field(vendorShipmentNo; Rec."Vendor Shipment No.")
                {
                    Caption = 'Vendor Shipment No.';
                }
                // field(attachment; Attachmentbase64)
                // {
                //     Caption = 'Attachment';
                // }
                // field(attachmentFileName; Rec."Attachment File Name")
                // {
                //     Caption = 'Attachment File Name';
                // }
                // field(attachmentFileExtension; Rec."Attachment File Extension")
                // {
                //     Caption = 'Attachment File Extension';
                // }

                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(processStatus; Rec."Process Status")
                {
                    Caption = 'Process Status';
                }
                field(processErrorLog; Rec."Process Error Log")
                {
                    Caption = 'Process Error Log';
                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SingleInstance_lCdu: Codeunit "INT Single Instance";
        DocumentAttachment_lRec: Record "Document Attachment";
        Count_lInt: Integer;
        DecimalValue_lTxt: List of [Text];
        DUCValue_lTxt: Text;
    begin

        Rec.TestField("Document No");
        Rec.TestField("Line No");
        Rec.TestField("Vendor Shipment No.");



        DecimalValue_lTxt := Format(Rec."Qty. to Receive").Split('.');
        if DecimalValue_lTxt.Count > 1 then
            Count_lInt := StrLen(DecimalValue_lTxt.Get(2));
        If Count_lInt > 5 then
            Error('Your entry of %1 is not an acceptable value for Qty. to Receive The field can have a maximum of 5 decimal places', Rec."Qty. to Receive");


        Clear(PurchaseHeader_gRec);
        if Not PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Order, Rec."Document No") then begin
            Error('Purchase Order with Document No %1 does not exist', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Order with Document No ' + Rec."Document No" + ' does not exist';
        End;

        Clear(PurchaseLine_gRec);
        if PurchaseLine_gRec.Get(PurchaseLine_gRec."Document Type"::Order, Rec."Document No", Rec."Line No") then begin
            SingleInstance_lCdu.Getbase64(Attachmentbase64, AttachmentFileName, AttachmentFileExtension);
            If Attachmentbase64 <> '' then begin
                DocumentAttachment_lRec.Reset();
                DocumentAttachment_lRec.SetRange("Table ID", 38);
                DocumentAttachment_lRec.SetRange("No.", Rec."Document No");
                DocumentAttachment_lRec.SetRange("Document Type", DocumentAttachment_lRec."Document Type"::Order);
                DocumentAttachment_lRec.SetRange("File Name", AttachmentFileName);
                If not DocumentAttachment_lRec.FindFirst() then
                    InsertAttachment;
            end;
            If PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Order, Rec."Document No") then Begin
                PurchaseHeader_gRec.Validate("Vendor Shipment No.", Rec."Vendor Shipment No.");
                PurchaseHeader_gRec.Modify();
            End;
            If Rec."Qty. to Receive" > 0 then
                PurchaseLine_gRec.Validate("Vendor Ship Qty.", Rec."Qty. to Receive");
            PurchaseLine_gRec.Modify();
        end
        else begin
            Error('Purchase Line with Document No %1 Line No %2 does not exist', Rec."Document No", Rec."Line No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Line with Document No ' + Rec."Document No" + 'Line No' + Format(Rec."Line No") + ' does not exist';
        end;
        Rec."Process Status" := Rec."Process Status"::Success;
    end;

    var
        PurchaseLine_gRec: Record "Purchase Line";
        PurchaseHeader_gRec: Record "Purchase Header";
        Attachmentbase64: Text;
        AttachmentFileName: Text[1000];
        AttachmentFileExtension: Enum "Document Attachment File Type";

    local procedure InsertAttachment()
    var
        Out: OutStream;
        Ins: InStream;
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        DocumentAttachment_lRec: Record "Document Attachment";
        FindDocumentAttachment_lRec: Record "Document Attachment";
        LineNo_lInt: Integer;
    begin
        Clear(LineNo_lInt);

        FindDocumentAttachment_lRec.Reset();
        FindDocumentAttachment_lRec.SetRange("Table ID", 38);
        FindDocumentAttachment_lRec.SetRange("No.", Rec."Document No");
        FindDocumentAttachment_lRec.SetRange("Document Type", DocumentAttachment_lRec."Document Type"::Order);
        FindDocumentAttachment_lRec.SetRange("File Name", Rec."Attachment File Name");
        If Not FindDocumentAttachment_lRec.FindFirst() then Begin
            DocumentAttachment_lRec.Reset();
            DocumentAttachment_lRec.SetRange("Table ID", 38);
            DocumentAttachment_lRec.SetRange("No.", Rec."Document No");
            DocumentAttachment_lRec.SetRange("Document Type", DocumentAttachment_lRec."Document Type"::Order);
            If DocumentAttachment_lRec.FindLast() then
                LineNo_lInt := DocumentAttachment_lRec."Line No." + 10000;


            DocumentAttachment_lRec.Reset();
            DocumentAttachment_lRec.Init();
            DocumentAttachment_lRec."Table ID" := 38;
            DocumentAttachment_lRec."No." := Rec."Document No";
            DocumentAttachment_lRec."Document Type" := DocumentAttachment_lRec."Document Type"::Order;
            DocumentAttachment_lRec."Line No." := LineNo_lInt;
            Clear(TempBlob);
            Clear(Out);
            Clear(Ins);
            TempBlob.CreateOutStream(Out);
            Base64Convert.FromBase64(Attachmentbase64, Out);
            TempBlob.CreateInStream(Ins);
            DocumentAttachment_lRec."Document Reference ID".ImportStream(Ins, '');
            DocumentAttachment_lRec."File Name" := AttachmentFileName;
            DocumentAttachment_lRec."File Type" := AttachmentFileExtension;
            DocumentAttachment_lRec."File Extension" := Format(AttachmentFileExtension);
            DocumentAttachment_lRec.Insert(true);
        End;
    end;
}
//T13751-NE