page 81277 "API_Proc_CustomerStatistics"    //"INT Web Portal - Statistics"  --> CustomerStatistics_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCustomerStatistic';
    DelayedInsert = true;
    EntityName = 'apiCustomerStatistic';
    EntityCaption = 'apiCustomerStatistic';
    EntitySetName = 'apiCustomerStatistics';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCustomerStatistics';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(loginTypeiTxt; Rec.LoginType_iTxt)
                {
                    ApplicationArea = All;
                }
                field(accountNoiCod; Rec.AccountNo_iCod)
                {
                    ApplicationArea = All;
                }
                field(balancevDec; Rec.Balance_vDec)
                {
                    ApplicationArea = All;
                }
                field(outstandingOrdersvDec; Rec.OutstandingOrders_vDec)
                {
                    ApplicationArea = All;
                }
                field(overdueAmountvDec; Rec.OverdueAmount_vDec)
                {
                    ApplicationArea = All;
                }
                field(creditLimitsvDec; Rec.CreditLimits_vDec)
                {
                    ApplicationArea = All;
                }
                field(paymentsCountvInt; Rec.PaymentsCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(postedInvoiceCountvInt; Rec.PostedInvoiceCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(salesCrMemoHeaderCountvInt; Rec.SalesCrMemoHeaderCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(lastLoginDateTimevDte; Rec.LastLoginDateTime_vDte)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        CustLedgerEntry_lRec: Record "Cust. Ledger Entry";
        Customer_lRec: Record Customer;
        WebPortalLoginHistory_lRec: Record "INT - Login History";
        SalesCrMemoHeader_lRec: Record "Sales Cr.Memo Header";
        SalesHeader_lRec: Record "Sales Header";
        SalesInvoiceHeader_lRec: Record "Sales Invoice Header";
    begin
        if Rec.LoginType_iTxt <> 'Customer' then
            Error('Login type must be customer.');

        Clear(Customer_lRec);
        Customer_lRec.Get(Rec.AccountNo_iCod);
        Customer_lRec.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Balance Due (LCY)");

        Rec.Balance_vDec := Customer_lRec."Balance (LCY)";
        //OutstandingOrders_vDec := Customer_lRec."Outstanding Orders (LCY)";

        Rec.OutstandingOrders_vDec := 0;
        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("Document Type", SalesHeader_lRec."Document Type"::Invoice);
        SalesHeader_lRec.SetRange("Bill-to Customer No.", Rec.AccountNo_iCod);
        if SalesHeader_lRec.FindSet() then
            repeat
                SalesHeader_lRec.CalcFields("Amount Including VAT");
                Rec.OutstandingOrders_vDec += SalesHeader_lRec."Amount Including VAT";
            until SalesHeader_lRec.Next() = 0;

        Rec.OutstandingOrders_vDec := Round(Rec.OutstandingOrders_vDec, 1);

        Rec.OverdueAmount_vDec := Customer_lRec."Balance Due (LCY)";
        Rec.CreditLimits_vDec := Customer_lRec."Credit Limit (LCY)";
        if Rec.CreditLimits_vDec > 0 then;

        Clear(SalesInvoiceHeader_lRec);
        SalesInvoiceHeader_lRec.SetRange("Sell-to Customer No.", Rec.AccountNo_iCod);
        Rec.PostedInvoiceCount_vInt := SalesInvoiceHeader_lRec.Count();

        Clear(SalesCrMemoHeader_lRec);
        SalesCrMemoHeader_lRec.SetRange("Sell-to Customer No.", Rec.AccountNo_iCod);
        Rec.SalesCrMemoHeaderCount_vInt := SalesCrMemoHeader_lRec.Count();

        Clear(CustLedgerEntry_lRec);
        CustLedgerEntry_lRec.SetRange("Sell-to Customer No.", Rec.AccountNo_iCod);
        CustLedgerEntry_lRec.SetRange("Document Type", CustLedgerEntry_lRec."Document Type"::Payment);
        Rec.PaymentsCount_vInt := CustLedgerEntry_lRec.Count();

        WebPortalLoginHistory_lRec.Reset();
        WebPortalLoginHistory_lRec.SetRange("Account No.", Rec.AccountNo_iCod);
        if WebPortalLoginHistory_lRec.FindLast() then
            Rec.LastLoginDateTime_vDte := WebPortalLoginHistory_lRec."Login DateTime";
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

}

