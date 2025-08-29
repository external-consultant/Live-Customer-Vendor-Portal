page 81242 "INT - Notification(NAV)"
{
    // version WebPortal,ForNAVOnly

    Caption = 'Notification Management';
    CardPageId = "INT - Notification";
    PageType = List;
    SourceTable = "INT - Notification";
    SourceTableView = sorting("Entry No");

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Select; Select_gBln)
                {
                    ApplicationArea = All;
                    Caption = 'Select_gBln';
                    ToolTip = 'Specifies the value of the Select_gBln field.';

                    trigger OnValidate()
                    var
                        WebPortalNotificationMgmt_lCdu: Codeunit "INT Web Portal-Notif(NAV)";
                    begin
                        Clear(WebPortalNotificationMgmt_lCdu);
                        WebPortalNotificationMgmt_lCdu.FillData_gFnc(Rec, Select_gBln);
                        //CurrPage.UPDATE;
                    end;
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
        area(Processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(Activation)
                {
                    ApplicationArea = All;
                    Caption = 'Activate';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Activate action.';

                    trigger OnAction()
                    var
                        WebPortalNotificationMgmt_lCdu: Codeunit "INT Web Portal-Notif(NAV)";
                    begin
                        Clear(WebPortalNotificationMgmt_lCdu);
                        WebPortalNotificationMgmt_lCdu.UpdateDataActivate_gFnc();
                        Select_gBln := false;
                        WebPortalNotificationMgmt_lCdu.ClearTable_gFnc();
                        CurrPage.Update(true);
                    end;
                }
                action(Deactivate)
                {
                    ApplicationArea = All;
                    Caption = 'Deactivate';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Deactivate action.';

                    trigger OnAction()
                    var
                        WebPortalNotificationMgmt_lCdu: Codeunit "INT Web Portal-Notif(NAV)";
                    begin
                        Clear(WebPortalNotificationMgmt_lCdu);
                        WebPortalNotificationMgmt_lCdu.UpdateDataDeActivate_gFnc();
                        Select_gBln := false;
                        WebPortalNotificationMgmt_lCdu.ClearTable_gFnc();
                        CurrPage.Update(true);
                    end;
                }
                action("Add Common Notification")
                {
                    ApplicationArea = All;
                    Caption = 'Add Common Notification';
                    Image = Add;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = report "INT - Notification Broadcast";
                    ToolTip = 'Executes the Add Common Notification action.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
        WebPortalNotificationMgmt_lCdu: Codeunit "INT Web Portal-Notif(NAV)";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        Select_gBln := false;
        Clear(WebPortalNotificationMgmt_lCdu);
        WebPortalNotificationMgmt_lCdu.ClearTable_gFnc();
    end;

    var
        Select_gBln: Boolean;
}

