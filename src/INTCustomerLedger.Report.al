report 81230 "INT Customer Ledger"
{
    Caption = 'Customer Ledger';
    DefaultLayout = RDLC;
    ApplicationArea = All;
    UsageCategory = Administration;
    RDLCLayout = './Customer Ledger.rdlc';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.")
                                order(ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter", "Global Dimension 1 Filter";
            column(No_Customer; "No.")
            {
            }
            column(Name_Customer; Name)
            {
            }
            column(Customer__No____________Customer_Name; Customer."No." + '  ' + Customer.Name)
            {
            }
            column(Date_Filter_Customer; "Date Filter")
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today(), 0, 4))
            {
            }
            column(CompInfo_gRec_Name; CompInfo_gRec.Name)
            {
            }
            column(GETFILTERS; GetFilters())
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
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = field("No."),
                               "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Customer No.", "Posting Date", "Document No.")
                                    order(ascending)
                                    where("Entry Type" = filter('Initial Entry|Unrealized Loss|Unrealized Gain|Realized Loss|Realized Gain|Payment Tolerance'));
                PrintOnlyIfDetail = true;
                column(Entry_No_Detailed_Cust__Ledg__Entry; "Entry No.")
                {
                }
                column(Customer_No_Detailed_Cust__Ledg__Entry; "Customer No.")
                {
                }
                column(Posting_Date_Cust__Ledger_Entry; "Posting Date")
                {
                }
                column(Document_No__Cust__Ledger_Entry; "Document No.")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Debit_Amount__LCY__Cust__Ledger_Entry; "Debit Amount (LCY)")
                {
                }
                column(Credit_Amount__LCY__Cust__Ledger_Entry; "Credit Amount (LCY)")
                {
                }
                column(Original_Amount_Cust__Ledger_Entry; "Debit Amount")
                {
                }
                column(Credit_Amount_Cust__Ledger_Entry; "Credit Amount")
                {
                }
                column(Currency_Code_Cust__Ledger_Entry; "Currency Code")
                {
                }
                column(AccountName_gTxt; AccountName_gTxt)
                {
                }
                column(ABS_OpeningDRBal_gDec_OpeningCRBal_gDec_TransDebits_gDec_TransCredits_gDec__Cust_Ledger_Entry; Abs(OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec))
                {
                }
                column(DrCrTextBalance_gTxt_Cust__Ledger_Entry; DrCrTextBalance_gTxt)
                {
                }
                column(PaymentDetails_gCod; PaymentDetails_gCod)
                {
                }
                column(CheckDate_gDt; CheckDate_gDt)
                {
                }
                column(ShowAmtInLCY_gBln; ShowAmtIn1LCY_gBln)
                {
                }
                column(Description_CustomerLedgerEntry_gRec; CustomerLedgerEntry_gRec.Description)
                {
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "Document No." = field("Document No.");
                    DataItemTableView = sorting("G/L Account No.", "Posting Date")
                                        order(ascending);
                    RequestFilterFields = "Source Code";
                    column(G_L_Account_No_G_L_Entry; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry__Amount_G_L_Entry; Amount)
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
                    column(AccountName_gTxt_Control1500018; AccountName_gTxt)
                    {
                    }
                    column(ABS__G_L_Entry__Amount_; Abs("G/L Entry".Amount))
                    {
                    }
                    column(DrCrText_gTxt; DrCrText_gTxt)
                    {
                    }
                    column(PrintDetail_gBln; PrintDetail_gBln)
                    {
                    }
                    column(TransDebits_gDec; TransDebits_gDec)
                    {
                    }
                    column(TransCredits_gDec; TransCredits_gDec)
                    {
                    }
                    column(BypAcc_gCod; BypAcc_gCod)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry___Entry_Type_; "Detailed Cust. Ledg. Entry"."Entry Type")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GLEntry_gRec.SetRange("Transaction No.", "Transaction No.");
                        GLEntry_gRec.SetFilter("Entry No.", '<>%1', "Entry No.");
                        if GLEntry_gRec.FindFirst() then;
                        Clear(DrCrText_gTxt);
                        //OneEntryRecord_gBln := true;
                        //if GLEntry_gRec.Count() > 1 then
                        //    OneEntryRecord_gBln := false;
                        if ("Detailed Cust. Ledg. Entry"."Currency Code" <> '') and not ShowAmtIn1LCY_gBln then begin
                            Currency_gRec.Get("Detailed Cust. Ledg. Entry"."Currency Code");
                            if "G/L Entry"."G/L Account No." in [Currency_gRec."Unrealized Gains Acc.", Currency_gRec."Realized Gains Acc.",
                             Currency_gRec."Unrealized Losses Acc.", Currency_gRec."Realized Losses Acc."] then
                                CurrReport.Skip();
                        end;
                        if not ShowAmtIn1LCY_gBln then
                            "G/L Entry".Amount := "G/L Entry".Amount * CustomerLedgerEntry_gRec."Original Currency Factor";
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
                    DetailedCustLedEntry_gRec.Reset();
                    CustomerLedgerEntry_gRec.Reset();
                    BankAccLedgerEntry_gRec.Reset();
                    CustomerLedgerEntry_gRec.SetRange("Entry No.", "Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                    if CustomerLedgerEntry_gRec.FindFirst() then begin
                        CustomerLedgerEntry_gRec."Document Type" := "Detailed Cust. Ledg. Entry"."Document Type";
                        if CustomerLedgerEntry_gRec."Document Type" = CustomerLedgerEntry_gRec."Document Type"::Invoice then
                            PaymentDetails_gCod := CustomerLedgerEntry_gRec."External Document No."
                        else begin
                            BankAccLedgerEntry_gRec.Reset();
                            BankAccLedgerEntry_gRec.SetRange("Posting Date", CustomerLedgerEntry_gRec."Posting Date");
                            BankAccLedgerEntry_gRec.SetRange("Document Type", BankAccLedgerEntry_gRec."Document Type"::Payment);
                            BankAccLedgerEntry_gRec.SetRange("Document No.", CustomerLedgerEntry_gRec."Document No.");
                            if BankAccLedgerEntry_gRec.FindFirst() then begin
                                CheckLedgerEntry_lRec.Reset();
                                CheckLedgerEntry_lRec.SetRange("Document No.", BankAccLedgerEntry_gRec."Document No.");
                                CheckLedgerEntry_lRec.SetRange("Posting Date", BankAccLedgerEntry_gRec."Posting Date");
                                if CheckLedgerEntry_lRec.FindLast() then begin
                                    PaymentDetails_gCod := CheckLedgerEntry_lRec."Check No.";
                                    CheckDate_gDt := CheckLedgerEntry_lRec."Check Date";
                                end;
                            end
                        end;
                        Clear(AccountName_gTxt);
                        AccountName_gTxt := CustomerLedgerEntry_gRec.Description;
                        Clear(DrCrTextBalance_gTxt);
                        if ShowAmtIn1LCY_gBln then begin
                            TransDebits_gDec += "Detailed Cust. Ledg. Entry"."Debit Amount (LCY)";
                            TransCredits_gDec += "Detailed Cust. Ledg. Entry"."Credit Amount (LCY)";
                            if OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec >= 0 then
                                DrCrTextBalance_gTxt := 'Dr'
                            else
                                DrCrTextBalance_gTxt := 'Cr';
                        end
                        else
                            if (("Detailed Cust. Ledg. Entry"."Entry Type" = "Detailed Cust. Ledg. Entry"."Entry Type"::"Initial Entry") or
                              ("Detailed Cust. Ledg. Entry"."Entry Type" = "Detailed Cust. Ledg. Entry"."Entry Type"::"Payment Tolerance")) then begin
                                TransDebits_gDec += "Detailed Cust. Ledg. Entry"."Debit Amount";
                                TransCredits_gDec += "Detailed Cust. Ledg. Entry"."Credit Amount";
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

                Clear(TransDebits_gDec);
                Clear(TransCredits_gDec);
                CustPostGrp_gRec.SetRange(CustPostGrp_gRec.Code, Customer."Customer Posting Group");
                if CustPostGrp_gRec.Find('-') then
                    BypAcc_gCod := CustPostGrp_gRec."Receivables Account";
                Clear(OpeningDRBal_gDec);
                Clear(OpeningCRBal_gDec);
                Clear(OpeningBalance_gDec);
                CustomerLedgEntry_gRec.Reset();
                CustomerLedgEntry_gRec.SetCurrentKey("Customer No.", "Posting Date");
                CustomerLedgEntry_gRec.SetRange("Customer No.", Customer."No.");
                CustomerLedgEntry_gRec.SetFilter(CustomerLedgEntry_gRec."Date Filter", '%1..%2', 0D, NormalDate(GetRangeMin("Date Filter")) - 1);
                if "Global Dimension 1 Filter" <> '' then
                    CustomerLedgEntry_gRec.SetFilter("Global Dimension 1 Code", "Global Dimension 1 Filter");
                if "Global Dimension 2 Filter" <> '' then
                    CustomerLedgEntry_gRec.SetFilter("Global Dimension 2 Code", "Global Dimension 2 Filter");
                if CustomerLedgEntry_gRec.FindFirst() then
                    repeat
                        if ShowAmtIn1LCY_gBln then begin
                            CustomerLedgEntry_gRec.CalcFields("Original Amt. (LCY)");
                            OpeningBalance_gDec += CustomerLedgEntry_gRec."Original Amt. (LCY)";
                        end
                        else begin
                            CustomerLedgEntry_gRec.CalcFields("Original Amount");
                            OpeningBalance_gDec += CustomerLedgEntry_gRec."Original Amount";
                        end;
                    until CustomerLedgEntry_gRec.Next() = 0;
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
                if (OpeningDRBal_gDec - OpeningCRBal_gDec + TransDebits_gDec - TransCredits_gDec >= 0) then
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
                    Customer.SetCurrentKey(Name);

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
                    field(ShowAmtInLCY_gBln; ShowAmtIn1LCY_gBln)
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
        Text16500_gCtx = 'As per Details';
        CurrReport_PAGENOCaptionLbl = 'Page';
        Post_DateCaptionLbl = 'Post Date';
        Document_No_CaptionLbl = 'Document No.';
        Debit_AmountCaptionLbl = 'Debit Amount';
        Credit_AmountCaptionLbl = 'Credit Amount';
        Account_NameCaptionLbl = 'Account Name';
        BalanceCaptionLbl = 'Balance';
        Cust__Ledger_Entry__Document_Type_CaptionLbl = 'Document Type';
        Bill_Check_No_CaptionLbl = 'PO/Check No.';
        DateCaptionLbl = 'Date';
        Currency_CodeCaptionLbl = 'Currency Code';
        CustomerLedgerCaptionLbl = 'CUSTOMER LEDGER';
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
        CustomerLedgEntry_gRec: Record "Cust. Ledger Entry";
        CustomerLedgerEntry_gRec: Record "Cust. Ledger Entry";
        CustPostGrp_gRec: Record "Customer Posting Group";
        DetailedCustLedEntry_gRec: Record "Detailed Cust. Ledg. Entry";
        GlAc_gRec: Record "G/L Account";
        GLEntry_gRec: Record "G/L Entry";
        PrintDetail_gBln: Boolean;
        ShowAmtIn1LCY_gBln: Boolean;
        SortByName1_gBln: Boolean;
        BypAcc_gCod: Code[20];
        PaymentDetails_gCod: Code[35];
        CheckDate_gDt: Date;
        EndDateRpt: Date;
        StartDateRpt: Date;
        ClosingCredits_gDec: Decimal;
        ClosingDebits_gDec: Decimal;
        OpeningBalance_gDec: Decimal;
        OpeningCRBal_gDec: Decimal;
        OpeningDRBal_gDec: Decimal;
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

