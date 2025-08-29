page 81256 "INT Vendor Statement"
{
    // version WebPortal

    Caption = 'Vendor Statement';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group("")
            {
                field(FromDate; FromDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Enter Start Date';
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Enter To Date';
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
                    WebPortalReportPrints.PrintVendorStatementD365_gFnc(SingleInstance.GetAccountNo(), FromDate, ToDate, SingleInstance.GetUserName());
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
                    WebPortalReportPrints.PrintVendorStatementEXCELD365_gFnc(SingleInstance.GetAccountNo(), FromDate, ToDate, SingleInstance.GetUserName());
                end;
            }
        }
    }

    var
        FromDate: Date;
        ToDate: Date;
}

