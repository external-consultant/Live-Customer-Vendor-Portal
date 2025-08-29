page 81279 "API_Proc_VendorStatistics"    //"INT Web Portal - Statistics"  --> VendorStatistics_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiVendorStatistic';
    DelayedInsert = true;
    EntityName = 'apiVendorStatistic';
    EntityCaption = 'apiVendorStatistic';
    EntitySetName = 'apiVendorStatistics';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiVendorStatistics';
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
                field(overDueAmountCountvInt; Rec.OverDueAmountCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(pendingPurchOrdCountvInt; Rec.PendingPurchOrdCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(postedPurchRcptCountvInt; Rec.PostedPurchRcptCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(postedDebitNotesCountvInt; Rec.PostedDebitNotesCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(pastPurchInvCountvInt; Rec.PastPurchInvCount_vInt)
                {
                    ApplicationArea = All;
                }
                field(lastLoginDateTimevDte; Rec.LastLoginDateTime_vDte)
                {
                    ApplicationArea = All;
                }
                field(paymentsCountvInt; Rec.PaymentsCount_vInt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
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
        if Rec.LoginType_iTxt <> 'Vendor' then
            Error('Login type must be Vendor.');

        Clear(Vendor_lRec);
        Vendor_lRec.Get(Rec.AccountNo_iCod);
        Vendor_lRec.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Balance Due (LCY)");

        Rec.Balance_vDec := Vendor_lRec."Balance (LCY)";
        Rec.OutstandingOrders_vDec := Vendor_lRec."Outstanding Orders (LCY)";
        Rec.OverdueAmount_vDec := Vendor_lRec."Balance Due (LCY)";

        Rec.CreditLimits_vDec := Vendor_lRec."Debit Amount (LCY)";
        if Rec.CreditLimits_vDec > 0 then;


        Clear(PurchaseLine1_lRec);
        PurchaseLine1_lRec.SetRange("Document Type", PurchaseLine1_lRec."Document Type"::Order);
        PurchaseLine1_lRec.SetRange(Type, PurchaseLine1_lRec.Type::Item);
        PurchaseLine1_lRec.SetFilter("No.", '<>%1', '');
        PurchaseLine1_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        PurchaseLine1_lRec.SetFilter("Outstanding Quantity", '>%1', 0);
        PurchaseLine1_lRec.SetFilter("Requested Receipt Date", '<%1', Today());
        Rec.OverDueAmountCount_vInt := PurchaseLine1_lRec.Count();

        Clear(PurchaseLine2_lRec);
        PurchaseLine2_lRec.SetRange("Document Type", PurchaseLine2_lRec."Document Type"::Order);
        PurchaseLine2_lRec.SetRange(Type, PurchaseLine2_lRec.Type::Item);
        PurchaseLine2_lRec.SetFilter("No.", '<>%1', '');
        PurchaseLine2_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        PurchaseLine2_lRec.SetFilter("Outstanding Quantity", '>%1', 0);
        PurchaseLine2_lRec.SetFilter("Requested Receipt Date", '<%1', Today());
        Rec.PendingPurchOrdCount_vInt := PurchaseLine2_lRec.Count();

        Clear(PurchRcptHeader_lRec);
        PurchRcptHeader_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        Rec.PostedPurchRcptCount_vInt := PurchRcptHeader_lRec.Count();

        Clear(PurchCrMemoHdr_lRec);
        PurchCrMemoHdr_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        Rec.PostedDebitNotesCount_vInt := PurchCrMemoHdr_lRec.Count();

        Clear(PurchInvHeader_lRec);
        PurchInvHeader_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        Rec.PastPurchInvCount_vInt := PurchInvHeader_lRec.Count();

        WebPortalLoginHistory_lRec.Reset();
        WebPortalLoginHistory_lRec.SetRange("Account No.", Rec.AccountNo_iCod);
        if WebPortalLoginHistory_lRec.FindLast() then
            Rec.LastLoginDateTime_vDte := WebPortalLoginHistory_lRec."Login DateTime";

        Clear(VendorLedgerEntry_lRec);
        VendorLedgerEntry_lRec.SetRange("Buy-from Vendor No.", Rec.AccountNo_iCod);
        VendorLedgerEntry_lRec.SetRange("Document Type", VendorLedgerEntry_lRec."Document Type"::Payment);
        Rec.PaymentsCount_vInt := VendorLedgerEntry_lRec.Count();
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

}

