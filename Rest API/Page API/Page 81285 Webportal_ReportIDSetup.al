page 81285 Webportal_ReportIDSetup
{
    Caption = 'Web Portal ReportID Setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Webportal_ReportIDSetup;

    layout
    {
        area(Content)
        {
            repeater(ReportWebPortal)
            {
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Report Name field.';
                }

                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object ID to Run field.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Caption to Run field.';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetParameters)
            {
                trigger OnAction()
                var
                    ReqPagePara: Text;
                begin
                    ReqPagePara := Report.RunRequestPage(Rec."Report ID");
                    Message(ReqPagePara);
                end;
            }
        }
    }

}