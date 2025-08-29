page 81269 "API_Notification"
{
    // version WebPortal

    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiNotification';
    DelayedInsert = true;
    EntityName = 'apiNotification';
    EntityCaption = 'apiNotification';
    EntitySetName = 'apiNotifications';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiNotifications';
    PageType = API;
    SourceTable = "INT - Notification";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(entryNo; Rec."Entry No")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No';
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field(date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(notificationType; Rec."Notification Type")
                {
                    ApplicationArea = All;
                    Caption = 'Notification Type';
                    ToolTip = 'Specifies the value of the Notification Type field.';
                }
                field(notification; Rec.Notification)
                {
                    ApplicationArea = All;
                    Caption = 'Notification';
                    ToolTip = 'Specifies the value of the Notification field.';
                }
                field(loginType; Rec."Login Type")
                {
                    ApplicationArea = All;
                    Caption = 'Login Type';
                    ToolTip = 'Specifies the value of the Login Type field.';
                }
                field(accountNo; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(customerName; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(activate; Rec.Activate)
                {
                    ApplicationArea = All;
                    Caption = 'Activate';
                    ToolTip = 'Specifies the value of the Activate field.';
                }
                field(closeByUser; Rec."Close By User")
                {
                    ApplicationArea = All;
                    Caption = 'Close By User';
                    ToolTip = 'Specifies the value of the Close By User field.';
                }
                field(lastModifiedBy; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Caption = 'Last Modified By';
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Last Modified Date Time';
                    ToolTip = 'Specifies the value of the Last Modified Date Time field.';
                }
                field(createdBy; Rec."Created By")
                {
                    ApplicationArea = All;
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(createdByDateTime; Rec."Created By Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Created By Date Time';
                    ToolTip = 'Specifies the value of the Created By Date Time field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

