page 81297 "API_Sales Cred. Memo Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiSalesCredMemoLine';
    DelayedInsert = true;
    EntityName = 'apiSalesCredMemoLine';
    EntityCaption = 'apiSalesCredMemoLine';
    EntitySetName = 'apiSalesCredMemoLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiSalesCredMemoLines';
    PageType = API;
    SourceTable = "Sales Cr.Memo Line";
    SourceTableView = where(Type = filter(<> ''), Quantity = filter(<> 0));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(selltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(ExternalDocumentNo_gCode; ExternalDocumentNo_gCode)
                {

                }
                field(ReasonDesc_gTxt; ReasonDesc_gTxt)
                {

                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(uom; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                // field(directunitCost; Rec."Direct Unit Cost")
                // {
                //     Caption = 'Unit Cost';
                // }
                field(unitPrice; Rec."Unit Price")
                {
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(GstAmount_gDec; GstAmount_gDec)
                {
                }
                field(Netamount_gDec; Netamount_gDec)
                {
                }
                field(CurrencyCode_gCode; CurrencyCode_gCode)
                { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ReturnReason_lRec: Record "Return Reason";
        SalesCrMemoHeader_lRec: Record "Sales Cr.Memo Header";
        RefInvNo_lRec: Record "Reference Invoice No.";
        GenralLedSetup_lRec: Record "General Ledger Setup";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTCSSalesManagement_gCdu: Codeunit "INT2 TCS Sales Management_BP";

    begin
        Clear(ReasonDesc_gTxt);
        Clear(ExternalDocumentNo_gCode);
        Clear(GstAmount_gDec);
        Clear(Netamount_gDec);
        Clear(Reference_gCode);

        if Rec."Return Reason Code" <> '' then begin
            ReturnReason_lRec.Reset();
            if ReturnReason_lRec.Get(Rec."Return Reason Code") then
                ReasonDesc_gTxt := ReturnReason_lRec.Description;
        end;

        SalesCrMemoHeader_lRec.Reset();
        if SalesCrMemoHeader_lRec.Get(Rec."Document No.") then begin
            ExternalDocumentNo_gCode := SalesCrMemoHeader_lRec."External Document No.";
            CurrencyCode_gCode := SalesCrMemoHeader_lRec."Currency Code";
        end;

        if CurrencyCode_gCode = '' then begin
            GenralLedSetup_lRec.Reset();
            if GenralLedSetup_lRec.Get() then
                CurrencyCode_gCode := GenralLedSetup_lRec."LCY Code";
        end;
        // RefInvNo_lRec.Reset();
        // RefInvNo_lRec.SetRange("Document Type" , RefInvNo_lRec."Document Type"::"Credit Memo");
        // RefInvNo_lRec.SetRange("Document No.", Rec."Document No.");
        // if RefInvNo_lRec.FindFirst() then begin
        //     Reference_gCode := RefInvNo_lRec."Reference Invoice Nos.";
        // end;

        Clear(GSTAmount_gDec);
        Clear(GSTStatistics_gCdu);
        GSTAmount_gDec := GSTStatistics_gCdu.GetGSTAmount(Rec.RecordId);

        Clear(TCSAmount_gDec);
        clear(INTTCSSalesManagement_gCdu);
        TCSAmount_gDec := INTTCSSalesManagement_gCdu.GetTCSAmount(rec.RecordId);

        Clear(NetAmount_gDec);
        NetAmount_gDec := Rec.Amount + TCSAmount_gDec + GSTAmount_gDec;


    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

    end;

    var

        GstAmount_gDec: Decimal;
        Netamount_gDec: Decimal;
        ExternalDocumentNo_gCode: Code[35];
        ReasonDesc_gTxt: Text;
        Reference_gCode: Code[20];
        CurrencyCode_gCode: Code[20];
        TCSAmount_gDec: Decimal;
}
