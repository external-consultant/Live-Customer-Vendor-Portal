page 81253 "INT Customer Dashboard"
{
    // version WebPortal

    Caption = 'Customer Dashboard';
    SourceTable = Customer;
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
                    group("Past Invoices")
                    {
                        Caption = 'Past Invoices';
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
                    group("Credit Notes")
                    {
                        Caption = 'Credit Notes';
                        field(CreditNotesCount; CreditNotesCount)
                        {
                            ApplicationArea = All;
                            Caption = 'Credit Notes';
                            Editable = false;
                            MultiLine = true;
                            ShowCaption = false;
                            Style = Favorable;
                            StyleExpr = true;
                            ToolTip = 'Specifies the value of the Credit Notes field.';
                        }
                    }
                    group(Payments)
                    {
                        Caption = 'Payments';
                        field(PaymentsCount1; PaymentsCount)
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
                Caption = 'Account Info';
                grid("Account Info")
                {
                    Caption = '';
                    GridLayout = Columns;
                    group(Gr4)
                    {
                        Caption = '';
                        field(AccountN; Customer."No.")
                        {
                            ApplicationArea = All;
                            Caption = 'Account No.';
                            Editable = false;
                            ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                        }
                        field(AccountName; Customer.Name)
                        {
                            ApplicationArea = All;
                            Caption = 'Account Name';
                            Editable = false;
                            ToolTip = 'Specifies the customer''s name.';
                        }
                        field(OutstandingOrders; OutstandingOrders)
                        {
                            ApplicationArea = All;
                            Caption = 'Outstanding Orders';
                            Editable = false;
                            ToolTip = 'Specifies the value of the Outstanding Orders field.';
                        }
                    }
                    group(Gr5)
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
                group(Gr6)
                {
                    Caption = '';
                    part("Customer Statement"; "INT Customer Statement")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Gr7)
            {
                Caption = '';
                part(PastInvoices; "INT Web Portal-Posted Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Past Invoices';
                    ShowFilter = false;
                    SubPageLink = "Sell-to Customer No." = field("No.");
                    SubPageView = sorting("No.");
                }
                part(CreditNotes; "INT Web-Posted Cred.Note")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Notes';
                    ShowFilter = false;
                    SubPageLink = "Sell-to Customer No." = field("No.");
                    SubPageView = sorting("No.");
                }
            }
            group(Gr8)
            {
                Caption = '';
                part("INT - Customer Payments"; "INT - Customer Payments")
                {
                    ApplicationArea = All;
                    Caption = 'Payments';
                    ShowFilter = false;
                    SubPageLink = "Customer No." = field("No.");
                    SubPageView = sorting("Entry No.");
                }
                part("INT - Pending Sales Inv."; "INT - Pending Sales Inv.")
                {
                    ApplicationArea = All;
                    Caption = 'Pending Invoices';
                    ShowFilter = false;
                    SubPageLink = "Sell-to Customer No." = field("No.");
                    SubPageView = sorting("Document Type", "No.");
                }
            }
            group(Gr9)
            {
                Caption = '';
                part("INT -Check Information"; "INT -Check Information")
                {
                    ApplicationArea = All;
                    Caption = 'Check Informations';
                    Editable = false;
                    ShowFilter = false;
                    SubPageLink = "Account No." = field("No.");
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
        Clear(Customer);
        Customer.Get(SingleInstance.GetAccountNo());

        Clear(WebPortalStatistics);
        WebPortalStatistics.CustomerStatistics_gFnc('Customer', Customer."No.", CustBalance, OutstandingOrders, OverdueAmount, CreditLimits, PaymentsCount, PastInvoiceCount, CreditNotesCount, LastLoggedIn);

        OnlyDateText := '';
        OnlyTime := DT2Time(LastLoggedIn);
        OnlyDate := DT2Date(LastLoggedIn);
        OnlyDateText := Format(OnlyDate, 0, '<Month,2>/<Day,2>/<Year4>') + ' ' + Format(OnlyTime);
    end;

    var
        Customer: Record Customer;
        SingleInstance: Codeunit "INT Single Instance";
        WebPortalStatistics: Codeunit "INT Web Portal - Statistics";
        LastLoggedIn: DateTime;
        CreditLimits: Decimal;
        CustBalance: Decimal;
        OutstandingOrders: Decimal;
        OverdueAmount: Decimal;
        CreditNotesCount: Integer;
        PastInvoiceCount: Integer;
        PaymentsCount: Integer;
        OnlyDateText: Text[50];
}

