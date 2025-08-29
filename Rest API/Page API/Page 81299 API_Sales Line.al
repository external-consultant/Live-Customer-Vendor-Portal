page 81299 "API_Sales Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiSalesLine';
    DelayedInsert = true;
    EntityName = 'apiSalesLine';
    EntityCaption = 'apiSalesLine';
    EntitySetName = 'apiSalesLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiSalesLines';
    PageType = API;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order), Quantity = filter(<> 0), Type = filter(<> ''), StatusfromSalesHeader = filter('Released'));

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
                field(completelyShipped; Rec."Completely Shipped")
                {
                    Caption = 'Completely Shipped';
                }
                field(orderDate; OrderDate_gDate)
                {
                    Caption = 'Order Date';
                }
                field(promisedDeliveryDate; Rec."Promised Delivery Date")
                {
                    Caption = 'Promised Delivery Date';
                }
                field(QuoteNo_gCode; QuoteNo_gCode)
                { }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(yourRefNo_gTxt; YourRefNo_gTxt)
                { }
                field(salesPersonName; SalesPersonName_gTxt)
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
                field(unitPrice; Rec."Unit Price")
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
                field(TCSAmount_gDec; TCSAmount_gDec)
                {
                    Caption = 'TDS Amount';
                }
                // field(totalExcl; TotalExclVAT_gDec)
                // {
                //     Caption = 'Total Excl';
                // }
                field(netAmount_gDec; NetAmount_gDec)
                {
                    Caption = 'Purchase LCY';
                }
                // field(quoteNo; Rec."Quote No.")
                // {
                //     Caption = 'Quote No.';
                // }
                // field(vendorOrderNo; Rec."Vendor Order No.")
                // {
                //     Caption = 'Vendor Order No.';
                // }

                field(currencyCode; CurrencyCode_gCode)
                {
                    Caption = 'Currency Code';
                }
                field(status; Rec.StatusfromSalesHeader)
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
        PaymentTerms_lRec: Record "Payment Terms";
        SalesHeader_lRec: Record "Sales Header";
        SalesPeople_lRec: Record "Salesperson/Purchaser";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTCSSalesManagement_gCdu: Codeunit "INT2 TCS Sales Management_BP";

    begin
        Clear(CurrencyCode_gCode);
        Clear(TotalExclVAT_gDec);
        Clear(GSTAmount_gDec);
        Clear(TotalInclTaxAmount);
        Clear(PurchaserName_gTxt);
        Clear(PaymentTermsDescription_gTxt);
        Clear(SalesPerson_gCode);
        Clear(SalesPersonName_gTxt);
        Clear(QuoteNo_gCode);
        Clear(PaymentTermsDesc_gTxt);
        Clear(PaymentTermsCode_gCode);
        Clear(OrderDate_gDate);
        Clear(YourRefNo_gTxt);

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;

        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("Document Type", SalesHeader_lRec."Document Type"::Order);
        SalesHeader_lRec.SetRange("No.", Rec."Document No.");
        IF SalesHeader_lRec.FindFirst() then begin
            PaymentTermsCode_gCode := SalesHeader_lRec."Payment Terms Code";
            SalesPerson_gCode := SalesHeader_lRec."Salesperson Code";
            QuoteNo_gCode := SalesHeader_lRec."Quote No.";
            OrderDate_gDate := (SalesHeader_lRec."Order Date");
            YourRefNo_gTxt := SalesHeader_lRec."Your Reference";

        end;

        if PaymentTermsCode_gCode <> '' then begin
            Paymentterms_lRec.Reset();
            if Paymentterms_lRec.Get(PaymentTermsCode_gCode) then begin
                PaymentTermsDesc_gTxt := Paymentterms_lRec.Description;
            end;
        end;

        if SalesPerson_gCode <> '' then begin
            SalesPeople_lRec.Reset();
            if SalesPeople_lRec.Get(SalesPerson_gCode) then begin
                SalesPersonName_gTxt := SalesPeople_lRec.Name;
            end;
        end;

        Clear(GSTAmount_gDec);
        Clear(GSTStatistics_gCdu);
        GSTAmount_gDec := GSTStatistics_gCdu.GetGSTAmount(Rec.RecordId);

        Clear(TCSAmount_gDec);
        clear(INTTCSSalesManagement_gCdu);
        TCSAmount_gDec := INTTCSSalesManagement_gCdu.GetTCSAmount(rec.RecordId);

        Clear(NetAmount_gDec);
        NetAmount_gDec := Rec.Amount + TCSAmount_gDec + GSTAmount_gDec;


        Clear(promisedDeliveryDate_gTxt);
        promisedDeliveryDate_gTxt := '';
        if Rec."Promised Delivery Date" <> 0D then begin
            promisedDeliveryDate_gTxt := Format(Rec."Promised Delivery Date")
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
        promisedDeliveryDate_gTxt: Text[20];
        NetAmount_gDec: Decimal;
        OrderDate_gDate: Date;
        YourRefNo_gTxt: Text[35];

        TotalExclVAT_gDec: Decimal;

        GSTAmount_gDec: Decimal;
        TotalInclTaxAmount: Decimal;
        PurchaserName_gTxt: Text;
        PaymentTermsDescription_gTxt: Text;
        CurrencyCode_gCode: Code[10];
        SalesPerson_gCode: Code[20];
        SalesPersonName_gTxt: Text;
        QuoteNo_gCode: Code[20];
        PaymentTermsDesc_gTxt: Text;
        PaymentTermsCode_gCode: Code[20];

        TCSAmount_gDec: Decimal;



}
