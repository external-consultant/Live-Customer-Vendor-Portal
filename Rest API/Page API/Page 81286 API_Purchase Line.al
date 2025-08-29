page 81286 "API_Purchase Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseLine';
    DelayedInsert = true;
    EntityName = 'apiPurchaseLine';
    EntityCaption = 'apiPurchaseLine';
    EntitySetName = 'apiPurchaseLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPurchaseLines';
    PageType = API;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = filter(Order), Type = filter(<> ''), Quantity = filter(<> 0), Statusfrompurchaseheader = filter('Released'));

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
                field(completelyReceived; Rec."Completely Received")
                {
                    Caption = 'Completely Received';
                }

                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(promisedReceiptDate; Rec."Promised Receipt Date")
                {
                    Caption = 'Promised Receipt Date';
                }
                field(QuoteNo_gCode; QuoteNo_gCode)
                { }

                field(orderNo; Rec."Document No.")
                {
                    Caption = 'Order No.';
                }
                field(vendororderNo_gDec; VendorOrderNo_gDec)
                { }
                field(purchasername; PurchaserDesc_gTxt)
                { }
                field(paymentterms; PaymentTermsDesc_gTxt)
                {
                    Caption = 'Payment Terms Description';
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

                field(outstandingQuantity; Rec."Outstanding Quantity")
                {
                    Caption = 'Outstanding Quantity';
                }
                field(uom; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field(unitcost; Rec."Unit Cost")
                { }
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
                // field(paymentTermsCode; Rec."Payment Terms Code")
                // {
                //     Caption = 'Payment Terms Code';
                // }
                // field(purchaserCode; Rec."Purchaser Code")
                // {
                //     Caption = 'Purchaser Code';
                // }
                field(gstAmount; GSTAmount_gDec)
                {
                    Caption = 'GST Amount';
                }
                field(TDSAmount_gDec; TDSAmount_gDec)
                {
                    Caption = 'TDS Amount';
                }
                field(totalExcl; TotalExclVAT_gDec)
                {
                    Caption = 'Total Excl';
                }

                field(nettotal; TotalInclTaxAmount)
                {
                    Caption = 'Net Total';
                }
                field(currencyCode; CurrencyCode_gCode)
                {
                    Caption = 'Currency Code';
                }
                field(status; Rec.Statusfrompurchaseheader)
                {
                    Caption = 'Status';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CalcStatistics: Codeunit "Calculate Statistics";
        GSTStatistics_lCdu: Codeunit "INT2 GST Statistics2_BP";
        GenralLedgSetup_lRec: Record "General Ledger Setup";
        PurchaseLines_lRec: Record "Purchase Line";
        PaymentTerms_lRec: Record "Payment Terms";
        PurchaseHeader_lRec: Record "Purchase Header";
        SalesPeople_lRec: Record "Salesperson/Purchaser";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTDSStatistics_gCdu: Codeunit "INT2 TDS Statistics_BP";
    begin
        Clear(CurrencyCode_gCode);
        Clear(TotalExclVAT_gDec);
        Clear(GSTAmount_gDec);
        Clear(TotalInclTaxAmount);
        Clear(PurchaserName_gTxt);
        Clear(PaymentTermsDescription_gTxt);
        Clear(PurchaserCode_gCode);
        Clear(PurchaserDesc_gTxt);
        Clear(QuoteNo_gCode);
        Clear(PaymentTermsDesc_gTxt);
        Clear(PaymentTermsCode_gCode);
        Clear(VendorOrderNo_gDec);
        Clear(Status_gTxt);

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;

        PurchaseLines_lRec.Reset();
        PurchaseLines_lRec.SetRange("Document Type", Rec."Document Type");
        PurchaseLines_lRec.SetRange("Document No.", Rec."No.");
        if PurchaseLines_lRec.Findset() then
            repeat
                TotalExclVAT_gDec := TotalExclVAT_gDec + PurchaseLines_lRec.Amount;
            until PurchaseLines_lRec.Next() = 0;


        PurchaseHeader_lRec.Reset();
        PurchaseHeader_lRec.SetRange("Document Type", PurchaseHeader_lRec."Document Type"::Order);
        PurchaseHeader_lRec.SetRange("No.", Rec."Document No.");
        IF PurchaseHeader_lRec.FindFirst() then begin
            PaymentTermsCode_gCode := PurchaseHeader_lRec."Payment Terms Code";
            PurchaserCode_gCode := PurchaseHeader_lRec."Purchaser Code";
            QuoteNo_gCode := PurchaseHeader_lRec."Quote No.";
            VendorOrderNo_gDec := PurchaseHeader_lRec."Vendor Order No.";
            Status_gTxt := Format(PurchaseHeader_lRec.Status);
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

        // # 
        Clear(GSTAmount_gDec);
        Clear(GSTStatistics_gCdu);
        GSTAmount_gDec := GSTStatistics_gCdu.GetGSTAmount(Rec.RecordId);

        Clear(TDSAmount_gDec);
        Clear(INTTDSStatistics_gCdu);
        TDSAmount_gDec := INTTDSStatistics_gCdu.GetTDSAmount(Rec.RecordId);

        Clear(TotalInclTaxAmount);
        TotalInclTaxAmount := Rec.Amount + TDSAmount_gDec + GSTAmount_gDec;

        Clear(promisedReceiptDate_gTxt);
        promisedReceiptDate_gTxt := '';
        if Rec."Promised Receipt Date" <> 0D then begin
            promisedReceiptDate_gTxt := Format(Rec."Promised Receipt Date")
        end;

        Clear(orderDate_gTxt);
        orderDate_gTxt := '';
        if Rec."Order Date" <> 0D then begin
            orderDate_gTxt := Format(Rec."Order Date")
        end;

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
        // GSTStatistics_gCdu: Codeunit "INT2 GST Statistics";
        promisedReceiptDate_gTxt: Text[20];
        orderDate_gTxt: Text[20];
        NetAmount_gDec: Decimal;
        RecCnt_gInt: Integer;
        TotalExclVAT_gDec: Decimal;
        PurchaseLCY_gDec: Decimal;
        GSTAmount_gDec: Decimal;
        TDSAmount_gDec: Decimal;
        TotalInclTaxAmount: Decimal;
        PurchaserName_gTxt: Text;
        PaymentTermsDescription_gTxt: Text;
        CurrencyCode_gCode: Code[10];
        PurchaserCode_gCode: Code[20];
        PurchaserDesc_gTxt: Text;
        QuoteNo_gCode: Code[20];
        PaymentTermsDesc_gTxt: Text;
        PaymentTermsCode_gCode: Code[20];
        VendorOrderNo_gDec: Code[20];
        Status_gTxt: Text;

}
