page 81295 "API_Sales Invoice Line"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiSalesInvLine';
    DelayedInsert = true;
    EntityName = 'apiSalesInvLine';
    EntityCaption = 'apiSalesInvLine';
    EntitySetName = 'apiSalesInvLines';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiSalesInvLines';
    PageType = API;
    SourceTable = "Sales Invoice Line";
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
                field(DueDate_gDate; DueDate_gDate)
                { }
                field(ExternalDocumentNo_gDec; ExternalDocumentNo_gDec)
                { }
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(shipmentNo; Rec."Shipment No.")
                { }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(SalespersonName_gTxt; SalespersonName_gTxt)
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
                field(unitPrice; Rec."Unit Price")
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
                field(gSTAmount_gDec; GSTAmount_gDec)
                { }
                field(tcsAmount_gDec; TCSAmount_gDec)
                {
                }
                field(netAmount_gDec; NetAmount_gDec)
                { }
                field(currencyCode_gCode; CurrencyCode_gCode)
                { }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesInvoiceHeader_lRec: Record "Sales Invoice Header";
        SalesPeople_lRec: Record "Salesperson/Purchaser";
        Paymentterms_lRec: Record "Payment Terms";
        GenralLedSetup_lRec: Record "General Ledger Setup";
        GSTStatistics_gCdu: Codeunit "INT2 GST Statistics2_BP";
        INTTCSSalesManagement_gCdu: Codeunit "INT2 TCS Sales Management_BP";

    begin
        Clear(CurrencyCode_gCode);
        Clear(GSTAmount_gDec);
        Clear(PaymentTermsDescription_gTxt);
        Clear(CurrencyCode_gCode);
        Clear(SalespersonCode_gCode);
        Clear(SalespersonName_gTxt);
        Clear(PaymentTermsDesc_gTxt);
        Clear(PaymentTermsCode_gCode);
        Clear(ExternalDocumentNo_gDec);

        SalesInvoiceHeader_lRec.Reset();
        if SalesInvoiceHeader_lRec.Get(Rec."Document No.") then begin
            ExternalDocumentNo_gDec := SalesInvoiceHeader_lRec."External Document No.";
            CurrencyCode_gCode := SalesInvoiceHeader_lRec."Currency Code";
            DueDate_gDate := SalesInvoiceHeader_lRec."Due Date";
            PaymentTermsCode_gCode := SalesInvoiceHeader_lRec."Payment Terms Code";
            SalespersonCode_gCode := SalesInvoiceHeader_lRec."Salesperson Code";
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

        if SalespersonCode_gCode <> '' then begin
            SalesPeople_lRec.Reset();
            if SalesPeople_lRec.Get(SalespersonCode_gCode) then begin
                SalespersonName_gTxt := SalesPeople_lRec.Name;
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
        PaymentTermsDescription_gTxt: Text;
        CurrencyCode_gCode: Code[10];
        SalespersonCode_gCode: Code[20];
        SalespersonName_gTxt: Text;
        PaymentTermsDesc_gTxt: Text;
        PaymentTermsCode_gCode: Code[20];
        ExternalDocumentNo_gDec: Code[35];
        GSTAmount_gDec: Decimal;
        DueDate_gDate: Date;
        NetAmount_gDec: Decimal;
        TCSAmount_gDec: Decimal;
}
