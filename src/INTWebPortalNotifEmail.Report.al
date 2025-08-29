report 81231 "INT Web Portal - Notif. Email"
{
    Caption = 'Notification';
    // version WebPortal

    ProcessingOnly = true;

    dataset
    {
        dataitem("Web Portal - Notification"; "INT - Notification")
        {
            DataItemTableView = sorting("Entry No")
                                where("E-mail Sent" = const(false));

            trigger OnAfterGetRecord()
            var
                CompanyInformation_lRec: Record "Company Information";
                WebPortalLoginTable_lRec: Record "INT - Login Table";
                WebPortalNotification_lRec: Record "INT - Notification";
                EmailMessage: Codeunit "Email Message";
                Email: Codeunit Email;
                // SubjectLbl: Label 'Notification';
                // TitleLbl: Label 'Notification';
                Recepients: List of [Text];
                BodyMessage_lTxt: Text;
                CompanyName_lTxt: Text;
                Recipients_lTxt: Text;
                // Sender_lTxt: Text;
                CustEmail_lTxt: Text[80];
                BodyHTML_lTxt: Text;
                CC: List of [Text];
                BCC: List of [Text];
            begin
                if GuiAllowed() then begin
                    Windows_gDlg.Update(1, "Web Portal - Notification"."Entry No");
                    NotifCount_gInt += 1;
                    Windows_gDlg.Update(3, NotifCount_gInt);
                end;

                BodyMessage_lTxt := Notification;

                Clear(WebPortalLoginTable_lRec);
                WebPortalLoginTable_lRec.SetRange("Login Type", "Login Type"::Customer);
                WebPortalLoginTable_lRec.SetRange("Account No.", "Account No.");
                if WebPortalLoginTable_lRec.FindFirst() then
                    CustEmail_lTxt := WebPortalLoginTable_lRec."User ID (E-Mail)";

                Clear(CompanyInformation_lRec);
                CompanyInformation_lRec.Get();
                CompanyName_lTxt := CompanyInformation_lRec.Name;

                if ForTest_gBln then
                    Recipients_lTxt := TestEmail_gTxt
                else
                    Recipients_lTxt := CustEmail_lTxt;


                //Sender_lTxt := SMTPMailSetup_gRec."User ID";

                Recepients.Add(Recipients_lTxt);
                //SMTPMail_lCdu.CreateMessage(TitleLbl, Sender_lTxt, Recepients, SubjectLbl, ' ');
                BodyHTML_lTxt := '';
                BodyHTML_lTxt += 'Hello,';
                BodyHTML_lTxt += '<BR/>';
                BodyHTML_lTxt += '<BR/>';

                BodyHTML_lTxt += 'You have Following Notifiaction:';
                BodyHTML_lTxt += '<BR/>';
                BodyHTML_lTxt += '<BR/>';

                BodyHTML_lTxt += BodyMessage_lTxt;
                BodyHTML_lTxt += '<BR/>';
                BodyHTML_lTxt += '<BR/>';

                BodyHTML_lTxt += 'Thanks,';
                BodyHTML_lTxt += '<BR/>';
                BodyHTML_lTxt += CompanyName_lTxt;
                Clear(Email);
                EmailMessage.Create(Recepients, 'SubjectLbl', BodyHTML_lTxt, true, CC, BCC);
                if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin

                    SuccessCount_gInt += 1;

                    Clear(WebPortalNotification_lRec);
                    WebPortalNotification_lRec.Get("Entry No");
                    WebPortalNotification_lRec."E-mail Sent" := true;
                    WebPortalNotification_lRec.Modify();
                end;
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed() then
                    Windows_gDlg.Close();
            end;

            trigger OnPreDataItem()
            begin
                if ForTest_gBln then
                    if TestEmail_gTxt = '' then
                        Error('Test Email ID cannot be blank');

                TotalNotiCount_gInt := Count();
                if GuiAllowed() then
                    Windows_gDlg.Update(2, TotalNotiCount_gInt);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("**** For Testing Only***")
                {
                    Caption = '**** For Testing Only***';
                    field("For Test"; ForTest_gBln)
                    {
                        ApplicationArea = All;
                        Caption = 'For Test';
                        ToolTip = 'Specifies the value of the For Test field.';
                    }
                    field("Test Email ID"; TestEmail_gTxt)
                    {
                        ApplicationArea = All;
                        Caption = 'Test Email ID';
                        ToolTip = 'Specifies the value of the Test Email ID field.';
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
        Message(Text0002Lbl, SuccessCount_gInt, TotalNotiCount_gInt);
    end;

    trigger OnPreReport()
    begin
        // SMTPMailSetup_gRec.Get();

        if GuiAllowed() then
            Windows_gDlg.Open('Notification No: #1#############\Total Notification: #2#########\Current Notification: #3#########');
    end;

    var
        // SMTPMailSetup_gRec: Record "SMTP Mail Setup";
        ForTest_gBln: Boolean;
        Windows_gDlg: Dialog;
        NotifCount_gInt: Integer;
        SuccessCount_gInt: Integer;
        TotalNotiCount_gInt: Integer;
        Text0002Lbl: Label '%1 out of %2 emails have been sent successfully.', Comment = '%1=Count,%2=Total Count';
        TestEmail_gTxt: Text;

}

