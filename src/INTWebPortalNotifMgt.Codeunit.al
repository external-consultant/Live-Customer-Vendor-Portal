codeunit 81239 "INT Web Portal-Notif Mgt"
{
    // version WebPortal

    trigger OnRun()
    begin
    end;

    procedure CloseNotification_gFnc(EntryNo_iInt: Integer): Boolean
    var
        WebPortalNotification_lRec: Record "INT - Notification";
    begin
        WebPortalNotification_lRec.Get(EntryNo_iInt);
        if WebPortalNotification_lRec."Notification Type" <> WebPortalNotification_lRec."Notification Type"::Accounts then
            exit(false);

        if WebPortalNotification_lRec."Close By User" then
            exit(false);

        WebPortalNotification_lRec.Validate("Close By User", true);
        WebPortalNotification_lRec.Modify();
        exit(true);
    end;
}

