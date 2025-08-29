page 81289 "API_Purchase Cred. Memo Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseCredMemoLine';
    DelayedInsert = true;
    EntityName = 'apiPurchaseCredMemoLine';
    EntityCaption = 'apiPurchaseCredMemoLine';
    EntitySetName = 'apiPurchaseCredMemoLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchaseCredMemoLines';
    PageType = API;
    SourceTable = "Purch. Cr. Memo Line";
    SourceTableView = where(Type = filter(<> ''), Quantity = filter(<> 0));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(VendorCreditMemoNo_gCode; VendorCreditMemoNo_gCode)
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
                field(unitcost; Rec."Unit Cost")
                {
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(gstAmount_gDec; GstAmount_gDec)
                {
                }
                field(tDSAmount_gDec; TDSAmount_gDec)
                {
                }
                field(netamount_gDec; Netamount_gDec)
                {
                }
                field(currencyCode_gCode; CurrencyCode_gCode)
                { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
        ReturnReason_lRec: Record "Return Reason";
        PurchaseCredMemoHeader_lRec: Record "Purch. Cr. Memo Hdr.";
        RefInvNo_lRec: Record "Reference Invoice No.";
        GenralLedSetup_lRec: Record "General Ledger Setup";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTDSStatistics_gCdu: Codeunit "INT2 TDS Statistics_BP";
    begin
        Clear(ReasonDesc_gTxt);
        Clear(VendorCreditMemoNo_gCode);
        Clear(GstAmount_gDec);
        Clear(Netamount_gDec);
        Clear(Reference_gCode);

        if Rec."Return Reason Code" <> '' then begin
            ReturnReason_lRec.Reset();
            if ReturnReason_lRec.Get(Rec."Return Reason Code") then
                ReasonDesc_gTxt := ReturnReason_lRec.Description;
        end;

        PurchaseCredMemoHeader_lRec.Reset();
        if PurchaseCredMemoHeader_lRec.Get(Rec."Document No.") then begin
            VendorCreditMemoNo_gCode := PurchaseCredMemoHeader_lRec."Vendor Cr. Memo No.";
            CurrencyCode_gCode := PurchaseCredMemoHeader_lRec."Currency Code";
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

        Clear(TDSAmount_gDec);
        Clear(INTTDSStatistics_gCdu);
        TDSAmount_gDec := INTTDSStatistics_gCdu.GetTDSAmount(Rec.RecordId);

        Clear(Netamount_gDec);
        Netamount_gDec := Rec.Amount + TDSAmount_gDec + GSTAmount_gDec;


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
        TDSAmount_gDec: Decimal;
        Netamount_gDec: Decimal;
        VendorCreditMemoNo_gCode: Code[20];
        ReasonDesc_gTxt: Text;
        Reference_gCode: Code[20];
        CurrencyCode_gCode: Code[20];
}
