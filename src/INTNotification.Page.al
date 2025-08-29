page 81243 "INT - Notification"
{
    // version WebPortal

    Caption = 'Notifications';
    Editable = false;
    PageType = List;
    SourceTable = "INT - Notification";
    SourceTableView = sorting("Entry No")
                      order(descending)
                      where(Activate = const(true),
                            "Close By User" = const(false));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No';
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Notification Type"; Rec."Notification Type")
                {
                    ApplicationArea = All;
                    Caption = 'Notification Type';
                    ToolTip = 'Specifies the value of the Notification Type field.';
                }
                field(Notification; Rec.Notification)
                {
                    ApplicationArea = All;
                    Caption = 'Notification';
                    ToolTip = 'Specifies the value of the Notification field.';
                }
                field("Login Type"; Rec."Login Type")
                {
                    ApplicationArea = All;
                    Caption = 'Login Type';
                    ToolTip = 'Specifies the value of the Login Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(Activate; Rec.Activate)
                {
                    ApplicationArea = All;
                    Caption = 'Activate';
                    ToolTip = 'Specifies the value of the Activate field.';
                }
                field("Close By User"; Rec."Close By User")
                {
                    ApplicationArea = All;
                    Caption = 'Close By User';
                    ToolTip = 'Specifies the value of the Close By User field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Caption = 'Last Modified By';
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Last Modified Date Time';
                    ToolTip = 'Specifies the value of the Last Modified Date Time field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created By Date Time"; Rec."Created By Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Created By Date Time';
                    ToolTip = 'Specifies the value of the Created By Date Time field.';
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

