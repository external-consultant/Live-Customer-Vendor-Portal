page 81302 WebportalAgeDetails
{
    Caption = 'Web Portal Age Details';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Age Details";

    layout
    {
        area(Content)
        {
            repeater(Vendor)
            {
                field("Vendor No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Age by"; Rec."Age by")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Age by field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Caption; Rec.Caption)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Caption field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source field.';
                }
                field(CaptionYear; Rec.CaptionYear)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}