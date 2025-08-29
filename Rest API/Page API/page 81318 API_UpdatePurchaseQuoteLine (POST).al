//T13751-NS
page 81318 API_UpdatePurchaseQuoteLine
{
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiUpdatePurchaseQuoteLine';
    DelayedInsert = true;
    EntityName = 'apiUpdatePurchaseQuoteLine';
    EntitySetName = 'apiUpdatePurchaseQuoteLines';               //Make Sure First Char in Small Letter and don't use any special char or space
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
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field(etd; Rec.ETD)
                {
                    Caption = 'ETD';
                }
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
        Count_lInt: Integer;
        DecimalValue_lTxt: List of [Text];
        DUCValue_lTxt: Text;
        Release_lTxt: Enum "Purchase Document Status";
    begin
        Clear(Release_lTxt);
        Rec.TestField("Document No");
        Rec.TestField("Line No");


        DecimalValue_lTxt := Format(Rec."Direct Unit Cost").Split('.');
        if DecimalValue_lTxt.Count > 1 then
            Count_lInt := StrLen(DecimalValue_lTxt.Get(2));
        If Count_lInt > 5 then
            Error('Your entry of %1 is not an acceptable value for Direct Unit Cost The field can have a maximum of 5 decimal places', Rec."Direct Unit Cost");

        Clear(PurchaseHeader_gRec);
        if Not PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Quote, Rec."Document No") then begin
            Error('Purchase Quote with Document No %1 does not exist', Rec."Document No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Quote with Document No ' + Rec."Document No" + ' does not exist';
        end else
            If PurchaseHeader_gRec.Status <> PurchaseHeader_gRec.Status::Open then Begin
                PurchaseHeader_gRec.Validate(Status, PurchaseHeader_gRec.Status::Open);
                PurchaseHeader_gRec.Modify();
                Release_lTxt := PurchaseHeader_gRec.Status;
            End;

        Clear(PurchaseLine_gRec);
        if PurchaseLine_gRec.Get(PurchaseLine_gRec."Document Type"::Quote, Rec."Document No", Rec."Line No") then begin
            // If Rec."Direct Unit Cost" > 0 then
            PurchaseLine_gRec.Validate("Direct Unit Cost", Rec."Direct Unit Cost");
            // If Rec.ETD <> 0D then
            PurchaseLine_gRec.Validate(CustomETD, Rec.ETD);
            PurchaseLine_gRec.Modify();
        end
        else begin
            Error('Purchase Line with Document No %1 Line No %2 does not exist', Rec."Document No", Rec."Line No");
            Rec."Process Status" := Rec."Process Status"::Failed;
            Rec."Process Error Log" := 'Purchase Line with Document No ' + Rec."Document No" + 'Line No' + Format(Rec."Line No") + ' does not exist';
        end;

        If Release_lTxt <> Release_lTxt::Open then begin
            PurchaseHeader_gRec.Get(PurchaseHeader_gRec."Document Type"::Quote, Rec."Document No");
            PurchaseHeader_gRec.Status := Release_lTxt;
            PurchaseHeader_gRec.Modify();
        end;
        Rec."Process Status" := Rec."Process Status"::Success;
    end;

    var
        PurchaseLine_gRec: Record "Purchase Line";
        PurchaseHeader_gRec: Record "Purchase Header";
}
//T13751-NE