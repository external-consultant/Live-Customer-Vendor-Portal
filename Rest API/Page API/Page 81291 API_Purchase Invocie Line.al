page 81291 "API_Purchase Invocie Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseInvLine';
    DelayedInsert = true;
    EntityName = 'apiPurchaseInvLine';
    EntityCaption = 'apiPurchaseInvLine';
    EntitySetName = 'apiPurchaseInvLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchaseInvLines';
    PageType = API;
    SourceTable = "Purch. Inv. Line";
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
                field(DueDate_gDate; DueDate_gDate)
                { }
                field(VendorInvoiceNo_gDec; VendorInvoiceNo_gDec)
                { }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(PurchaserDesc_gTxt; PurchaserDesc_gTxt)
                { }

                field(PaymentTermsDesc_gTxt; PaymentTermsDesc_gTxt)
                { }
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
                //   field(directUnitCost; Rec."Direct Unit Cost")
                // {
                //     Caption = 'Direct Unit Cost';
                // }
                field(unitcost; Rec."Unit Cost")
                {
                }
                field(lineDiscount; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                }
                field(lineAmount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(invDiscountAmount; Rec."Inv. Discount Amount")
                {
                    Caption = 'Inv. Discount Amount';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(GSTAmount_gDec; GSTAmount_gDec)
                { }
                field(TDSAmount_gDec; TDSAmount_gDec)
                {
                }
                field(NetAmount_gDec; NetAmount_gDec)
                { }
                field(CurrencyCode_gCode; CurrencyCode_gCode)
                { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchaseInvoiceHeader_lRec: Record "Purch. Inv. Header";
        SalesPeople_lRec: Record "Salesperson/Purchaser";
        Paymentterms_lRec: Record "Payment Terms";
        GenralLedSetup_lRec: Record "General Ledger Setup";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTDSStatistics_gCdu: Codeunit "INT2 TDS Statistics_BP";
    begin
        Clear(CurrencyCode_gCode);
        Clear(GSTAmount_gDec);
        Clear(PurchaserName_gTxt);
        Clear(PaymentTermsDescription_gTxt);
        Clear(CurrencyCode_gCode);
        Clear(PurchaserCode_gCode);
        Clear(PurchaserDesc_gTxt);
        Clear(QuoteNo_gCode);
        Clear(PaymentTermsDesc_gTxt);
        Clear(PaymentTermsCode_gCode);
        Clear(VendorInvoiceNo_gDec);

        PurchaseInvoiceHeader_lRec.Reset();
        if PurchaseInvoiceHeader_lRec.Get(Rec."Document No.") then begin
            VendorInvoiceNo_gDec := PurchaseInvoiceHeader_lRec."Vendor Invoice No.";
            CurrencyCode_gCode := PurchaseInvoiceHeader_lRec."Currency Code";
            DueDate_gDate := PurchaseInvoiceHeader_lRec."Due Date";
            PaymentTermsCode_gCode := PurchaseInvoiceHeader_lRec."Payment Terms Code";
            PurchaserCode_gCode := PurchaseInvoiceHeader_lRec."Purchaser Code";
        end;

        if CurrencyCode_gCode = '' then begin
            GenralLedSetup_lRec.Reset();
            if GenralLedSetup_lRec.Get() then
                CurrencyCode_gCode := GenralLedSetup_lRec."LCY Code";
        end;

        if PaymentTermsCode_gCode <> '' then begin
            Paymentterms_lRec.Reset();
            if Paymentterms_lRec.Get(PaymentTermsCode_gCode) then begin
                PaymentTermsDesc_gTxt := Paymentterms_lRec.Description;
            end;
        end;

        if PurchaserCode_gCode <> '' then begin
            SalesPeople_lRec.Reset();
            if SalesPeople_lRec.Get(PurchaserCode_gCode) then begin
                PurchaserDesc_gTxt := SalesPeople_lRec.Name;
            end;
        end;

        Clear(GSTAmount_gDec);
        Clear(GSTStatistics_gCdu);
        GSTAmount_gDec := GSTStatistics_gCdu.GetGSTAmount(Rec.RecordId);

        Clear(TDSAmount_gDec);
        Clear(INTTDSStatistics_gCdu);
        TDSAmount_gDec := INTTDSStatistics_gCdu.GetTDSAmount(Rec.RecordId);

        Clear(NetAmount_gDec);
        NetAmount_gDec := Rec.Amount + TDSAmount_gDec + GSTAmount_gDec;

    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        // Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

    end;

    var
        PurchaserName_gTxt: Text;
        PaymentTermsDescription_gTxt: Text;
        CurrencyCode_gCode: Code[10];
        PurchaserCode_gCode: Code[20];
        PurchaserDesc_gTxt: Text[50];
        QuoteNo_gCode: Code[20];
        PaymentTermsDesc_gTxt: Text[100];
        PaymentTermsCode_gCode: Code[20];
        VendorInvoiceNo_gDec: Code[35];
        GSTAmount_gDec: Decimal;
        DueDate_gDate: Date;
        NetAmount_gDec: Decimal;
        TDSAmount_gDec: Decimal;
}
