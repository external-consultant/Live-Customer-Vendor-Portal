codeunit 81234 "INT Web Portal - Statistics"
{
    // version WebPortal


    trigger OnRun()
    begin

        //VendorStatistics_gFnc('Vendor','VD000001',a,a,a,a,b,b,b,b);
        //CustomerStatistics_gFnc('Customer','CD00027',a,a,a,a,b,b,b,e);
        //CusVendtInfo_gFnc(c,d);
    end;

    procedure CustomerStatistics_gFnc(LoginType_iTxt: Text[50]; AccountNo_iCod: Code[20]; var Balance_vDec: Decimal; var OutstandingOrders_vDec: Decimal; var OverdueAmount_vDec: Decimal; var CreditLimits_vDec: Decimal; var PaymentsCount_vInt: Integer; var PostedInvoiceCount_vInt: Integer; var SalesCrMemoHeaderCount_vInt: Integer; var LastLoginDateTime_vDte: DateTime)
    var
        CustLedgerEntry_lRec: Record "Cust. Ledger Entry";
        Customer_lRec: Record Customer;
        WebPortalLoginHistory_lRec: Record "INT - Login History";
        SalesCrMemoHeader_lRec: Record "Sales Cr.Memo Header";
        SalesHeader_lRec: Record "Sales Header";
        SalesInvoiceHeader_lRec: Record "Sales Invoice Header";
    begin
        if LoginType_iTxt <> 'Customer' then
            Error('Login type must be customer.');

        Clear(Customer_lRec);
        Customer_lRec.Get(AccountNo_iCod);
        Customer_lRec.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Balance Due (LCY)");

        Balance_vDec := Customer_lRec."Balance (LCY)";
        //OutstandingOrders_vDec := Customer_lRec."Outstanding Orders (LCY)";

        OutstandingOrders_vDec := 0;
        SalesHeader_lRec.Reset();
        SalesHeader_lRec.SetRange("Document Type", SalesHeader_lRec."Document Type"::Invoice);
        SalesHeader_lRec.SetRange("Bill-to Customer No.", AccountNo_iCod);
        if SalesHeader_lRec.FindSet() then
            repeat
                SalesHeader_lRec.CalcFields("Amount Including VAT");
                OutstandingOrders_vDec += SalesHeader_lRec."Amount Including VAT";
            until SalesHeader_lRec.Next() = 0;

        OutstandingOrders_vDec := Round(OutstandingOrders_vDec, 1);

        OverdueAmount_vDec := Customer_lRec."Balance Due (LCY)";
        CreditLimits_vDec := Customer_lRec."Credit Limit (LCY)";
        if CreditLimits_vDec > 0 then;

        Clear(SalesInvoiceHeader_lRec);
        SalesInvoiceHeader_lRec.SetRange("Sell-to Customer No.", AccountNo_iCod);
        PostedInvoiceCount_vInt := SalesInvoiceHeader_lRec.Count();

        Clear(SalesCrMemoHeader_lRec);
        SalesCrMemoHeader_lRec.SetRange("Sell-to Customer No.", AccountNo_iCod);
        SalesCrMemoHeaderCount_vInt := SalesCrMemoHeader_lRec.Count();

        Clear(CustLedgerEntry_lRec);
        CustLedgerEntry_lRec.SetRange("Sell-to Customer No.", AccountNo_iCod);
        CustLedgerEntry_lRec.SetRange("Document Type", CustLedgerEntry_lRec."Document Type"::Payment);
        PaymentsCount_vInt := CustLedgerEntry_lRec.Count();

        WebPortalLoginHistory_lRec.Reset();
        WebPortalLoginHistory_lRec.SetRange("Account No.", AccountNo_iCod);
        if WebPortalLoginHistory_lRec.FindLast() then
            LastLoginDateTime_vDte := WebPortalLoginHistory_lRec."Login DateTime";
    end;

    procedure VendorStatistics_gFnc(LoginType_iTxt: Text[50]; AccountNo_iCod: Code[20]; var Balance_vDec: Decimal; var OutstandingOrders_vDec: Decimal; var OverdueAmount_vDec: Decimal; var CreditLimits_vDec: Decimal; var OverDueAmountCount_vInt: Integer; var PendingPurchOrdCount_vInt: Integer; var PostedPurchRcptCount_vInt: Integer; var PostedDebitNotesCount_vInt: Integer; var PastPurchInvCount_vInt: Integer; var LastLoginDateTime_vDte: DateTime; var PaymentsCount_vInt: Integer)
    var
        WebPortalLoginHistory_lRec: Record "INT - Login History";
        PurchCrMemoHdr_lRec: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader_lRec: Record "Purch. Inv. Header";
        PurchRcptHeader_lRec: Record "Purch. Rcpt. Header";
        PurchaseLine1_lRec: Record "Purchase Line";
        PurchaseLine2_lRec: Record "Purchase Line";
        Vendor_lRec: Record Vendor;
        VendorLedgerEntry_lRec: Record "Vendor Ledger Entry";
    begin
        if LoginType_iTxt <> 'Vendor' then
            Error('Login type must be Vendor.');

        Clear(Vendor_lRec);
        Vendor_lRec.Get(AccountNo_iCod);
        Vendor_lRec.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Balance Due (LCY)");

        Balance_vDec := Vendor_lRec."Balance (LCY)";
        OutstandingOrders_vDec := Vendor_lRec."Outstanding Orders (LCY)";
        OverdueAmount_vDec := Vendor_lRec."Balance Due (LCY)";

        CreditLimits_vDec := Vendor_lRec."Debit Amount (LCY)";
        if CreditLimits_vDec > 0 then;

        Clear(PurchaseLine1_lRec);
        PurchaseLine1_lRec.SetRange("Document Type", PurchaseLine1_lRec."Document Type"::Order);
        PurchaseLine1_lRec.SetRange(Type, PurchaseLine1_lRec.Type::Item);
        PurchaseLine1_lRec.SetFilter("No.", '<>%1', '');
        PurchaseLine1_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        PurchaseLine1_lRec.SetFilter("Outstanding Quantity", '>%1', 0);
        PurchaseLine1_lRec.SetFilter("Requested Receipt Date", '<%1', Today());
        OverDueAmountCount_vInt := PurchaseLine1_lRec.Count();

        Clear(PurchaseLine2_lRec);
        PurchaseLine2_lRec.SetRange("Document Type", PurchaseLine2_lRec."Document Type"::Order);
        PurchaseLine2_lRec.SetRange(Type, PurchaseLine2_lRec.Type::Item);
        PurchaseLine2_lRec.SetFilter("No.", '<>%1', '');
        PurchaseLine2_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        PurchaseLine2_lRec.SetFilter("Outstanding Quantity", '>%1', 0);
        PurchaseLine2_lRec.SetFilter("Requested Receipt Date", '<%1', Today());
        PendingPurchOrdCount_vInt := PurchaseLine2_lRec.Count();

        Clear(PurchRcptHeader_lRec);
        PurchRcptHeader_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        PostedPurchRcptCount_vInt := PurchRcptHeader_lRec.Count();

        Clear(PurchCrMemoHdr_lRec);
        PurchCrMemoHdr_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        PostedDebitNotesCount_vInt := PurchCrMemoHdr_lRec.Count();

        Clear(PurchInvHeader_lRec);
        PurchInvHeader_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        PastPurchInvCount_vInt := PurchInvHeader_lRec.Count();

        WebPortalLoginHistory_lRec.Reset();
        WebPortalLoginHistory_lRec.SetRange("Account No.", AccountNo_iCod);
        if WebPortalLoginHistory_lRec.FindLast() then
            LastLoginDateTime_vDte := WebPortalLoginHistory_lRec."Login DateTime";

        Clear(VendorLedgerEntry_lRec);
        VendorLedgerEntry_lRec.SetRange("Buy-from Vendor No.", AccountNo_iCod);
        VendorLedgerEntry_lRec.SetRange("Document Type", VendorLedgerEntry_lRec."Document Type"::Payment);
        PaymentsCount_vInt := VendorLedgerEntry_lRec.Count();
    end;

    procedure CusVendtInfo_gFnc(var LCYCode_vCod: Code[20]; var CompanyName_vTxt: Text[50]; CustomerVenCode_iCod: Code[20])
    var
        CompanyInformation_lRec: Record "Company Information";
        Customer_lRec: Record Customer;
        GeneralLedgerSetup_lRec: Record "General Ledger Setup";
        Vendor_lRec: Record Vendor;
    begin
        if Customer_lRec.Get(CustomerVenCode_iCod) then
            if Customer_lRec."Currency Code" <> '' then
                LCYCode_vCod := Customer_lRec."Currency Code"
            else begin
                GeneralLedgerSetup_lRec.Get();
                LCYCode_vCod := GeneralLedgerSetup_lRec."LCY Code";
            end;

        if Vendor_lRec.Get(CustomerVenCode_iCod) then
            if Vendor_lRec."Currency Code" <> '' then
                LCYCode_vCod := Vendor_lRec."Currency Code"
            else begin
                GeneralLedgerSetup_lRec.Get();
                LCYCode_vCod := GeneralLedgerSetup_lRec."LCY Code";
            end;

        CompanyInformation_lRec.Get();
        CompanyName_vTxt := COPYSTR(CompanyInformation_lRec.Name, 1, MaxStrLen(CompanyName_vTxt));
    end;
}

