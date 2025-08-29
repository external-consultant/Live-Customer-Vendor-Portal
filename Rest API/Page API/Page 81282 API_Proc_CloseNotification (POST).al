page 81282 "API_Proc_CloseNotification"  //"INT Web Portal-Notif Mgt"  --> CloseNotification_gFnc
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalNotifMgtProcCloseNotification';
    DelayedInsert = true;
    EntityName = 'apiWebPortalNotifMgtProcCloseNotification';
    EntityCaption = 'apiWebPortalNotifMgtProcCloseNotification';
    EntitySetName = 'apiWebPortalNotifMgtProcCloseNotifications';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalNotifMgtProcCloseNotifications';
    PageType = API;
    SourceTable = API_Post_Data;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(entryNo_iInt; Rec.EntryNo_iInt)
                {
                    ApplicationArea = All;
                }
                field(result_gBln; Rec.Result_gBln)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        WebPortalNotification_lRec: Record "INT - Notification";
    begin
        WebPortalNotification_lRec.Get(Rec.EntryNo_iInt);
        if WebPortalNotification_lRec."Notification Type" <> WebPortalNotification_lRec."Notification Type"::Accounts then
            Rec.Result_gBln := false;

        if WebPortalNotification_lRec."Close By User" then
            Rec.Result_gBln := false;

        WebPortalNotification_lRec.Validate("Close By User", true);
        WebPortalNotification_lRec.Modify();
        Rec.Result_gBln := false;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;


}

