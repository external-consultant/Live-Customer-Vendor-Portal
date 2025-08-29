page 81255 "INT Vendor Dashboard"
{
    // version WebPortal

    Caption = 'Vendor Dashboard';
    SourceTable = Vendor;
    SourceTableView = sorting("No.");

    layout
    {
        area(Content)
        {
            group(Gr1)
            {
                Caption = '';
                fixed(Gr2)
                {
                    Caption = '';
                    group("Posted Debit Notes")
                    {
                        Caption = 'Posted Debit Notes';
                        field(DebitNotesCount; DebitNotesCount)
                        {
                            ApplicationArea = All;
                            Caption = 'DebitNotesCount';
                            Editable = false;
                            MultiLine = true;
                            ShowCaption = false;
                            Style = Favorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the value of the DebitNotesCount field.';
                        }
                    }
                    group(Payments)
                    {
                        Caption = 'Payments';
                        field(PaymentsCount; PaymentsCount)
                        {
                            ApplicationArea = All;
                            Caption = 'Payments';
                            Editable = false;
                            MultiLine = true;
                            ShowCaption = false;
                            Style = Favorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the value of the Payments field.';
                        }
                    }
                    group("Past Purchase Invoices")
                    {
                        Caption = 'Past Purchase Invoices';
                        field(PastInvoiceCount; PastInvoiceCount)
                        {
                            ApplicationArea = All;
                            Caption = 'PastInvoiceCount';
                            Editable = false;
                            MultiLine = true;
                            ShowCaption = false;
                            Style = Favorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the value of the PastInvoiceCount field.';
                        }
                    }
                    group("Last Logged In")
                    {
                        Caption = 'Last Logged In';
                        field(OnlyDateText; OnlyDateText)
                        {
                            ApplicationArea = All;
                            Caption = 'Last Logged In';
                            Editable = false;
                            ShowCaption = false;
                            Style = Favorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the value of the Last Logged In field.';
                        }
                    }
                }
            }
            group(Gr3)
            {
                Caption = '';
                grid("Account Info")
                {
                    Caption = 'Account Info';
                    GridLayout = Columns;
                    group(Gr9)
                    {
                        Caption = '';
                        field(AccountN; Vendor."No.")
                        {
                            ApplicationArea = All;
                            Caption = 'Account No.';
                            Editable = false;
                            ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                        }
                        field(AccountName; Vendor.Name)
                        {
                            ApplicationArea = All;
                            Caption = 'Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                        }
                        field(OutstandingOrders; OutstandingOrders)
                        {
                            ApplicationArea = All;
                            Caption = 'Outstanding Orders';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Outstanding Orders field.';
                        }
                    }
                    group(Gr4)
                    {
                        Caption = '';
                        field(CustBalance; CustBalance)
                        {
                            ApplicationArea = All;
                            Caption = 'Balance';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Balance field.';
                        }
                        field(OverdueAmount; OverdueAmount)
                        {
                            ApplicationArea = All;
                            Caption = 'OverdueAmount';
                            Editable = false;
                            ToolTip = 'Specifies the value of the OverdueAmount field.';
                        }
                    }
                }
                group(Gr5)
                {
                    Caption = '';
                    part(VendorStatement; "INT Vendor Statement")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Gr6)
            {
                Caption = '';
                part("INT Web Portal-Pend Purch Ord"; "INT Web Portal-Pend Purch Ord")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Purchase Orders';
                    ShowFilter = false;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    SubPageView = sorting("No.");
                }
                part("INT - Posted Purch Rcpt"; "INT - Posted Purch Rcpt")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Receipts';
                    ShowFilter = false;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    SubPageView = sorting("No.");
                }
            }
            group(Gr7)
            {
                Caption = '';
                part("INT - Pending Purch Inv."; "INT - Pending Purch Inv.")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Invoices';
                    ShowFilter = false;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    SubPageView = sorting("No.");
                }
                part("INT - Posted Debit Note"; "INT - Posted Debit Note")
                {
                    ApplicationArea = All;
                    Caption = 'Debit Notes';
                    ShowFilter = false;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    SubPageView = sorting("No.");
                }
            }
            group(Gr8)
            {
                Caption = '';
                part("INT - Overdue Delivery"; "INT - Overdue Delivery")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Deliveries';
                    Editable = false;
                    ShowFilter = false;
                    SubPageLink = "Buy-from Vendor No." = field("No.");
                    SubPageView = sorting("Document Type", "Document No.", "Line No.");
                }
                part("INT - Vendor Payments"; "INT - Vendor Payments")
                {
                    ApplicationArea = All;
                    Caption = 'Payments';
                    ShowFilter = false;
                    SubPageLink = "Vendor No." = field("No.");
                    SubPageView = sorting("Entry No.");
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        OnlyDate: Date;
        OnlyTime: Time;
    begin
        Clear(Vendor);
        Vendor.Get(SingleInstance.GetAccountNo());

        Clear(WebPortalStatistics);
        WebPortalStatistics.VendorStatistics_gFnc('Vendor', Vendor."No.", CustBalance, OutstandingOrders, OverdueAmount, CreditLimits, temp1, temp2, temp3, DebitNotesCount, PastInvoiceCount, LastLoggedIn, PaymentsCount);

        OnlyDateText := '';
        OnlyTime := DT2Time(LastLoggedIn);
        OnlyDate := DT2Date(LastLoggedIn);
        OnlyDateText := Format(OnlyDate, 0, '<Month,2>/<Day,2>/<Year4>') + ' ' + Format(OnlyTime);
    end;

    var
        Vendor: Record Vendor;
        SingleInstance: Codeunit "INT Single Instance";
        WebPortalStatistics: Codeunit "INT Web Portal - Statistics";
        LastLoggedIn: DateTime;
        CreditLimits: Decimal;
        CustBalance: Decimal;
        OutstandingOrders: Decimal;
        OverdueAmount: Decimal;
        DebitNotesCount: Integer;
        PastInvoiceCount: Integer;
        PaymentsCount: Integer;
        temp1: Integer;
        temp2: Integer;
        temp3: Integer;
        OnlyDateText: Text[50];
}

