report 81234 "INT Vendor Ledger"
{
    Caption = 'Vendor Ledger';
    // version WebPortal
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = Administration;
    RDLCLayout = './Vendor Ledger.rdlc';


    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.")
                                order(ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(FORMAT_TODAY_0_4_; Format(Today(), 0, 4))
            {
            }
            column(CompInfo_gRec_Name; CompInfo_gRec.Name)
            {
            }
            column(GETFILTERS; GetFilters())
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__No____________Vendor_Name; Vendor."No." + '  ' + Vendor.Name)
            {
            }
            column(Vendor_No_; "No.")
            {
            }
            column(Vendor_Date_Filter; "Date Filter")
            {
            }
            column(Opening_Balance_As_On_______FORMAT_GETRANGEMIN__Date_Filter___; 'Opening Balance As On' + ' ' + Format(GetRangeMin("Date Filter")))
            {
            }
            column(OpeningDRBal_gDec; OpeningDRBal_gDec)
            {
            }
            column(OpeningCRBal_gDec; OpeningCRBal_gDec)
            {
            }
            column(DrCrTextBalance_gTxt; DrCrTextBalance_gTxt)
            {
            }
            column(ABS_OpeningDRBal_gDec_OpeningCRBal_gDec_; Abs(OpeningDRBal_gDec - OpeningCRBal_gDec))
            {
            }
            column(ClosingCredits_gDec; ClosingCredits_gDec)
            {
            }
            column(ClosingDebits_gDec; ClosingDebits_gDec)
            {
            }
            column(ABS_OpeningDRBal_gDec_OpeningCRBal_gDec_TransDebits_gDec_TransCredits_gDec_; Abs(OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec))
            {
            }
            column(DrCrTextBalance_gTxt_Vendor; DrCrTextBalance_gTxt)
            {
            }
            column(Closing_Balance_As_On_______FORMAT_GETRANGEMAX__Date_Filter___; 'Closing Balance As On' + ' ' + Format(GetRangeMax("Date Filter")))
            {
            }
            column(TotalDebits_gDec; TotalDebits_gDec)
            {
            }
            column(TotalCredits_gDec; TotalCredits_gDec)
            {
            }
            column(ABS_TotalDebits_gDec__TotalCredits_gDec_; Abs(TotalDebits_gDec - TotalCredits_gDec))
            {
            }
            column(TotalDrCrTextBalance_gTxt; TotalDrCrTextBalance_gTxt)
            {
            }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Vendor No." = field("No."),
                               "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Document No.")
                                    order(ascending)
                                    where("Entry Type" = filter('Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Discount'));
                column(Posting_Date_Vendor_Ledger_Entry; "Posting Date")
                {
                }
                column(Document_No_Vendor_Ledger_Entry; "Document No.")
                {
                }
                column(Document_Type_Vendor_Ledger_Entry; "Document Type")
                {
                }
                column(Debit_Amount__LCY_Vendor_Ledger_Entry; "Debit Amount (LCY)")
                {
                }
                column(Credit_Amount__LCY_Vendor_Ledger_Entry; "Credit Amount (LCY)")
                {
                }
                column(Debit_Amount_Vendor_Ledger_Entry; "Debit Amount")
                {
                }
                column(Credit_Amount_Vendor_Ledger_Entry; "Credit Amount")
                {
                }
                column(Currency_Code_Detailed_Vendor_Ledg__Entry; "Currency Code")
                {
                }
                column(Entry_No_Detailed_Vendor_Ledg__Entry; "Entry No.")
                {
                }
                column(Vendor_No_Detailed_Vendor_Ledg__Entry; "Vendor No.")
                {
                }
                column(AccountName_gTxt; AccountName_gTxt)
                {
                }
                column(ABS_OpeningDRBal_gDec_OpeningCRBal_gDec_TransDebits_gDec_TransCredits_gDec_Vendor_Ledg__Entry; Abs(OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec))
                {
                }
                column(DrCrTextBalance_gTxt_Vendor_Ledg__Entry; DrCrTextBalance_gTxt)
                {
                }
                column(PaymentDetails_gCod; PaymentDetails_gCod)
                {
                }
                column(CheckDate; CheckDate_gDat)
                {
                }
                column(ShowAmtInLCY_gBln; ShowAmtInLCY1_gBln)
                {
                }
                column(VendorLedgerEntry_gRec_Description; VendorLedgerEntry_gRec.Description)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Document No." = field("Document No.");
                    DataItemTableView = sorting("G/L Account No.", "Posting Date")
                                        order(ascending);
                    RequestFilterFields = "Source Code";
                    column(G_L_Account_No__G_L_Entry; "G/L Account No.")
                    {
                    }
                    column(Amount_G_L_Entry; Amount)
                    {
                    }
                    column(Entry_No_G_L_Entry; "Entry No.")
                    {
                    }
                    column(Document_No_G_L_Entry; "Document No.")
                    {
                    }
                    column(Transaction_No_G_L_Entry; "Transaction No.")
                    {
                    }
                    column(ABS__G_L_Entry__Amount_; Abs("G/L Entry".Amount))
                    {
                    }
                    column(AccountName_gTxt_G_L_Entry; AccountName_gTxt)
                    {
                    }
                    column(DrCrText_gTxt; DrCrText_gTxt)
                    {
                    }
                    column(PrintDetail_gBln; PrintDetail1_gBln)
                    {
                    }
                    column(BypAcc_gCod; BypAcc_gCod)
                    {
                    }
                    column(TransDebits_gDec; TransDebits_gDec)
                    {
                    }
                    column(TransCredits_gDec; TransCredits_gDec)
                    {
                    }
                    column(Entry_Type_Detailed_Vendor_Ledg__Entry; "Detailed Vendor Ledg. Entry"."Entry Type")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GLEntry_gRec.SetRange("Transaction No.", "Transaction No.");
                        GLEntry_gRec.SetFilter("Entry No.", '<>%1', "Entry No.");
                        if GLEntry_gRec.FindFirst() then;
                        DrCrText_gTxt := '';
                        //OneEntryRecord_gBln := true;
                        //if GLEntry_gRec.Count() > 1 then
                        //    OneEntryRecord_gBln := false;
                        if ("Detailed Vendor Ledg. Entry"."Currency Code" <> '') and not ShowAmtInLCY1_gBln then begin
                            Currency_gRec.Get("Detailed Vendor Ledg. Entry"."Currency Code");
                            if "G/L Entry"."G/L Account No." in [Currency_gRec."Unrealized Gains Acc.", Currency_gRec."Realized Gains Acc.",
                             Currency_gRec."Unrealized Losses Acc.", Currency_gRec."Realized Losses Acc."] then
                                CurrReport.Skip();
                        end;
                        if not ShowAmtInLCY1_gBln then
                            "G/L Entry".Amount := "G/L Entry".Amount * VendorLedgEntry_gRec."Original Currency Factor";
                        if "G/L Entry".Amount >= 0 then
                            DrCrText_gTxt := 'Dr'
                        else
                            DrCrText_gTxt := 'Cr';
                        GlAc_gRec.SetRange(GlAc_gRec."No.", "G/L Entry"."G/L Account No.");
                        if GlAc_gRec.Find('-') then
                            AccountName_gTxt := GlAc_gRec.Name;
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLEntry_gRec.Reset();
                        GLEntry_gRec.SetCurrentKey("Transaction No.");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    CheckLedgerEntry_lRec: Record "Check Ledger Entry";
                begin
                    Clear(PaymentDetails_gCod);
                    Clear(OrgAmtDeb_gDec);
                    Clear(OrgAmtCrd_gDec);
                    VendorLedgerEntry_gRec.Reset();
                    BankAccLedgerEntry_gRec.Reset();
                    DetailVendorLedEntry_gRec.Reset();
                    VendorLedgerEntry_gRec.SetRange("Entry No.", "Detailed Vendor Ledg. Entry"."Vendor Ledger Entry No.");
                    if VendorLedgerEntry_gRec.FindFirst() then begin
                        VendorLedgerEntry_gRec."Document Type" := "Detailed Vendor Ledg. Entry"."Document Type";
                        if VendorLedgerEntry_gRec."Document Type" = VendorLedgerEntry_gRec."Document Type"::Invoice then
                            PaymentDetails_gCod := VendorLedgerEntry_gRec."External Document No."
                        else begin
                            BankAccLedgerEntry_gRec.Reset();
                            BankAccLedgerEntry_gRec.SetRange("Posting Date", VendorLedgerEntry_gRec."Posting Date");
                            BankAccLedgerEntry_gRec.SetRange("Document Type", BankAccLedgerEntry_gRec."Document Type"::Payment);
                            BankAccLedgerEntry_gRec.SetRange("Document No.", VendorLedgerEntry_gRec."Document No.");
                            if BankAccLedgerEntry_gRec.FindFirst() then begin
                                PaymentDetails_gCod := CheckLedgerEntry_lRec."Check No.";
                                CheckDate_gDat := CheckLedgerEntry_lRec."Check Date";
                            end
                        end;
                        AccountName_gTxt := '';
                        AccountName_gTxt := VendorLedgerEntry_gRec.Description;
                        DrCrTextBalance_gTxt := '';
                        if ShowAmtInLCY1_gBln then begin
                            TransDebits_gDec += "Detailed Vendor Ledg. Entry"."Debit Amount (LCY)";
                            TransCredits_gDec += "Detailed Vendor Ledg. Entry"."Credit Amount (LCY)";
                            if OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec >= 0 then
                                DrCrTextBalance_gTxt := 'Dr'
                            else
                                DrCrTextBalance_gTxt := 'Cr';
                        end else
                            if ("Detailed Vendor Ledg. Entry"."Entry Type" = "Detailed Vendor Ledg. Entry"."Entry Type"::"Initial Entry")
                             or ("Detailed Vendor Ledg. Entry"."Entry Type" =
                             "Detailed Vendor Ledg. Entry"."Entry Type"::"Payment Discount")             //I-C0007-1260322-02
                             then begin
                                TransDebits_gDec += "Detailed Vendor Ledg. Entry"."Debit Amount";
                                TransCredits_gDec += "Detailed Vendor Ledg. Entry"."Credit Amount";
                                if OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec >= 0 then
                                    DrCrTextBalance_gTxt := 'Dr'
                                else
                                    DrCrTextBalance_gTxt := 'Cr';
                            end
                            else
                                CurrReport.Skip();
                    end;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                Cnt_gInt += 1;
                Win_gDlg.Update(2, Cnt_gInt);

                TransDebits_gDec := 0;
                TransCredits_gDec := 0;
                VendPostGrp_gRec.SetRange(VendPostGrp_gRec.Code, Vendor."Vendor Posting Group");
                if VendPostGrp_gRec.Find('-') then
                    BypAcc_gCod := VendPostGrp_gRec."Payables Account";
                OpeningDRBal_gDec := 0;
                OpeningCRBal_gDec := 0;
                OpeningBalance_gDec := 0;
                VendorLedgEntry_gRec.Reset();
                VendorLedgEntry_gRec.SetCurrentKey("Vendor No.", "Posting Date");
                VendorLedgEntry_gRec.SetRange("Vendor No.", Vendor."No.");
                VendorLedgEntry_gRec.SetFilter(VendorLedgEntry_gRec."Date Filter", '%1..%2', 0D, NormalDate(GetRangeMin("Date Filter")) - 1);
                if "Global Dimension 1 Filter" <> '' then
                    VendorLedgEntry_gRec.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Filter");
                if "Global Dimension 2 Filter" <> '' then
                    VendorLedgEntry_gRec.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Filter");
                if VendorLedgEntry_gRec.FindFirst() then
                    repeat
                        if ShowAmtInLCY1_gBln then begin
                            VendorLedgEntry_gRec.CalcFields("Original Amt. (LCY)");
                            OpeningBalance_gDec += VendorLedgEntry_gRec."Original Amt. (LCY)";
                        end
                        else begin
                            VendorLedgEntry_gRec.CalcFields("Original Amount");
                            OpeningBalance_gDec += VendorLedgEntry_gRec."Original Amount";
                        end;
                    until VendorLedgEntry_gRec.Next() = 0;
                if (OpeningBalance_gDec >= 0) then
                    OpeningDRBal_gDec := OpeningBalance_gDec
                else
                    OpeningCRBal_gDec := OpeningBalance_gDec * -1;
                DrCrTextBalance_gTxt := '';
                if OpeningDRBal_gDec - OpeningCRBal_gDec >= 0 then
                    DrCrTextBalance_gTxt := 'Dr'
                else
                    DrCrTextBalance_gTxt := 'Cr';
                ClosingDebits_gDec := OpeningDRBal_gDec + TransDebits_gDec;
                ClosingCredits_gDec := OpeningCRBal_gDec + TransCredits_gDec;
                DrCrTextBalance_gTxt := '';
                if OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec >= 0 then
                    DrCrTextBalance_gTxt := 'Dr'
                else
                    DrCrTextBalance_gTxt := 'Cr';
                TotalDebits_gDec += ClosingDebits_gDec;
                TotalCredits_gDec += ClosingCredits_gDec;
                if TotalDebits_gDec - TotalCredits_gDec >= 0 then
                    TotalDrCrTextBalance_gTxt := 'Dr'
                else
                    TotalDrCrTextBalance_gTxt := 'Cr';
            end;

            trigger OnPreDataItem()
            begin
                if SortByName1_gBln then
                    Vendor.SetCurrentKey(Name);

                Win_gDlg.Update(1, Count());
                if (StartDateRpt <> 0D) and (EndDateRpt <> 0D) then
                    SetFilter("Date Filter", '%1..%2', StartDateRpt, EndDateRpt);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(PrintDetail_gBln; PrintDetail1_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Detail';
                        ToolTip = 'Specifies the value of the Print Detail field.';
                    }
                    field(PrintLineNarration_gBln; PrintLineNarration1_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Line Narration';
                        ToolTip = 'Specifies the value of the Print Line Narration field.';
                    }
                    field(PrintVchNarration_gBln; PrintVchNarratio1n_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'Print Voucher Narration';
                        ToolTip = 'Specifies the value of the Print Voucher Narration field.';
                    }
                    field(ShowAmtInLCY_gBln; ShowAmtInLCY1_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Amount in LCY';
                        ToolTip = 'Specifies the value of the Show Amount in LCY field.';
                    }
                    field(SortByName_gBln; SortByName1_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'Sort By Name';
                        ToolTip = 'Specifies the value of the Sort By Name field.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Text16500 = 'As per Details';
        CurrReport_PAGENOCaptionLbl = 'Page';
        Post_DateCaptionLbl = 'Post Date';
        Document_No_CaptionLbl = 'Document No.';
        Debit_AmountCaptionLbl = 'Debit Amount';
        Credit_AmountCaptionLbl = 'Credit Amount';
        Account_NameCaptionLbl = 'Account Name';
        BalanceCaptionLbl = 'Balance';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl = 'Document Type';
        Bill_Check_No_CaptionLbl = 'Bill/Check No.';
        DateCaptionLbl = 'Date';
        Currency_CodeCaptionLbl = 'Currency Code';
        VendorLedgerCaptionLbl = 'VENDOR LEDGER';
        TotalBalanceCaptionLbl = 'Total Balance';
    }

    trigger OnPostReport()
    begin
        Win_gDlg.Close();
    end;

    trigger OnPreReport()
    begin
        CompInfo_gRec.Get();
        Win_gDlg.Open('Getting Data..\Total Count: #1###############\Current Count: #2###############');
    end;

    var
        BankAccLedgerEntry_gRec: Record "Bank Account Ledger Entry";
        CompInfo_gRec: Record "Company Information";
        Currency_gRec: Record Currency;
        DetailVendorLedEntry_gRec: Record "Detailed Vendor Ledg. Entry";
        GlAc_gRec: Record "G/L Account";
        GLEntry_gRec: Record "G/L Entry";
        VendorLedgEntry_gRec: Record "Vendor Ledger Entry";
        VendorLedgerEntry_gRec: Record "Vendor Ledger Entry";
        VendPostGrp_gRec: Record "Vendor Posting Group";
        //OneEntryRecord_gBln: Boolean;
        PrintDetail1_gBln: Boolean;
        PrintLineNarration1_gBln: Boolean;
        PrintVchNarratio1n_gBln: Boolean;
        ShowAmtInLCY1_gBln: Boolean;
        SortByName1_gBln: Boolean;
        BypAcc_gCod: Code[20];
        PaymentDetails_gCod: Code[35];
        CheckDate_gDat: Date;
        EndDateRpt: Date;
        StartDateRpt: Date;
        ClosingCredits_gDec: Decimal;
        ClosingDebits_gDec: Decimal;
        OpeningBalance_gDec: Decimal;
        OpeningCRBal_gDec: Decimal;
        OpeningDRBal_gDec: Decimal;
        OrgAmtCrd_gDec: Decimal;
        OrgAmtDeb_gDec: Decimal;
        TotalCredits_gDec: Decimal;
        TotalDebits_gDec: Decimal;
        TransCredits_gDec: Decimal;
        TransDebits_gDec: Decimal;
        Win_gDlg: Dialog;
        Cnt_gInt: Integer;
        DrCrText_gTxt: Text[2];
        DrCrTextBalance_gTxt: Text[2];
        TotalDrCrTextBalance_gTxt: Text[2];
        AccountName_gTxt: Text[100];


    procedure SetParameter(StartDate: Date; EndDate: Date)
    begin
        StartDateRpt := StartDate;
        EndDateRpt := EndDate;
    end;
}

