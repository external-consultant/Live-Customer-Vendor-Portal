report 81238 "INT - Notification Broadcast"
{
    Caption = 'Notification Broadcast';
    // version WebPortal

    ProcessingOnly = true;

    dataset
    {
        dataitem("Web Portal - Login Table"; "INT - Login Table")
        {
            RequestFilterFields = "Login Type", "Account No.";
            trigger OnAfterGetRecord()
            var
                WebPortalNotification_lRec: Record "INT - Notification";
                NotificationText_lTxt: Text[250];
            begin
                if GuiAllowed() then begin
                    Windows_gDlg.Update(1, "Web Portal - Login Table"."User ID (E-Mail)");
                    NotifCount_gInt += 1;
                    Windows_gDlg.Update(3, NotifCount_gInt);
                end;

                NotificationText_lTxt := NotificationText_gTxt;

                Clear(WebPortalNotification_lRec);
                WebPortalNotification_lRec.Init();
                WebPortalNotification_lRec."Account No." := "Web Portal - Login Table"."Account No.";
                WebPortalNotification_lRec."Login Type" := "Web Portal - Login Table"."Login Type";
                WebPortalNotification_lRec.Date := Today();
                WebPortalNotification_lRec."Notification Type" := WebPortalNotification_lRec."Notification Type"::All;
                WebPortalNotification_lRec.Notification := NotificationText_lTxt;
                Evaluate(WebPortalNotification_lRec."Created By", UserId());
                WebPortalNotification_lRec."Created By Date Time" := CurrentDateTime();
                WebPortalNotification_lRec.Insert(true);

                SuccessCount_gInt += 1;
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed() then
                    Windows_gDlg.Close();
            end;

            trigger OnPreDataItem()
            begin
                if NotificationText_gTxt = '' then
                    Error('You must Enter Notification');

                if GuiAllowed() then
                    Windows_gDlg.Update(2, Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("Enter Details about Notification")
                {
                    Caption = 'Enter Details about Notification';
                    field(Notification; NotificationText_gTxt)
                    {
                        ApplicationArea = All;
                        Caption = 'Notification';
                        ToolTip = 'Specifies the value of the Notification field.';
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
    }

    trigger OnPostReport()
    begin
        Message(Text0002Lbl, SuccessCount_gInt);
    end;

    trigger OnPreReport()
    begin
        // SMTPMailSetup_gRec.Get();

        if GuiAllowed() then
            Windows_gDlg.Open('User: #1#############\Total Notifications: #2#########\Current Notification: #3#########');
    end;

    var
        // SMTPMailSetup_gRec: Record "SMTP Mail Setup";
        Windows_gDlg: Dialog;
        NotifCount_gInt: Integer;
        SuccessCount_gInt: Integer;
        //TotalNotiCount_gInt: Integer;
        Text0002Lbl: Label '%1 Notifications Added.', Comment = '%1=Notification';
        NotificationText_gTxt: Text[250];
}

