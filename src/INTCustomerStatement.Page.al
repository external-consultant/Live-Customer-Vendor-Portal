page 81254 "INT Customer Statement"
{
    // version WebPortal

    Caption = 'Customer Statement';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(Gr1)
            {
                Caption = '';
                field(FromDate; FromDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Email PDF")
            {
                ApplicationArea = All;
                Caption = 'Email PDF';
                Image = ElectronicDoc;
                ToolTip = 'Executes the Email PDF action.';

                trigger OnAction()
                var
                    SingleInstance: Codeunit "INT Single Instance";
                    WebPortalReportPrints: Codeunit "INT Web Portal Report (Email)";
                begin
                    Clear(WebPortalReportPrints);
                    WebPortalReportPrints.PrintCustomerStatementD365_gFnc(SingleInstance.GetAccountNo(), FromDate, ToDate, SingleInstance.GetUserName());
                end;
            }
            action("Email Excel")
            {
                ApplicationArea = All;
                Caption = 'Email Excel';
                Image = ElectronicDoc;
                ToolTip = 'Executes the Email Excel action.';

                trigger OnAction()
                var
                    SingleInstance: Codeunit "INT Single Instance";
                    WebPortalReportPrints: Codeunit "INT Web Portal Report (Email)";
                begin
                    Clear(WebPortalReportPrints);
                    WebPortalReportPrints.PrintCustomerStatementEXCELD365_gFnc(SingleInstance.GetAccountNo(), FromDate, ToDate, SingleInstance.GetUserName());
                end;
            }
        }
    }

    var
        FromDate: Date;
        ToDate: Date;
}

