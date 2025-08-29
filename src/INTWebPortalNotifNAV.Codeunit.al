codeunit 81236 "INT Web Portal-Notif(NAV)"
{
    // version WebPortal,ForNAVOnly

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        TempWebPortalNotification_gRec: Record "INT - Notification" temporary;

    procedure ClearTable_gFnc()
    begin
        TempWebPortalNotification_gRec.Reset();
        TempWebPortalNotification_gRec.DeleteAll();
    end;

    procedure FillData_gFnc(WebPortalNotification_iRec: Record "INT - Notification"; Select_iBln: Boolean)
    begin
        TempWebPortalNotification_gRec.Reset();
        TempWebPortalNotification_gRec.SetRange("Entry No", WebPortalNotification_iRec."Entry No");
        if not TempWebPortalNotification_gRec.FindFirst() then begin
            TempWebPortalNotification_gRec.Init();
            TempWebPortalNotification_gRec."Entry No" := WebPortalNotification_iRec."Entry No";
            TempWebPortalNotification_gRec.Activate := Select_iBln;
            TempWebPortalNotification_gRec.Insert();
        end else begin
            TempWebPortalNotification_gRec.Activate := Select_iBln;
            TempWebPortalNotification_gRec.Modify();
        end;
    end;

    procedure UpdateDataActivate_gFnc()
    var
        WebPortalNotification_lRec: Record "INT - Notification";
    begin
        if not Confirm('Do you want to Activate Notification ?', true) then
            exit;
        TempWebPortalNotification_gRec.Reset();
        if TempWebPortalNotification_gRec.FindSet() then
            repeat
                WebPortalNotification_lRec.Reset();
                if WebPortalNotification_lRec.Get(TempWebPortalNotification_gRec."Entry No") then begin
                    WebPortalNotification_lRec.Activate := true;
                    WebPortalNotification_lRec.Modify();
                end;
            until TempWebPortalNotification_gRec.Next() = 0;
    end;

    procedure UpdateDataDeActivate_gFnc()
    var
        WebPortalNotification_lRec: Record "INT - Notification";
    begin
        if not Confirm('Do you want to DeActivate Notification ?', true) then
            exit;
        TempWebPortalNotification_gRec.Reset();
        if TempWebPortalNotification_gRec.FindSet() then
            repeat
                WebPortalNotification_lRec.Reset();
                if WebPortalNotification_lRec.Get(TempWebPortalNotification_gRec."Entry No") then begin
                    WebPortalNotification_lRec.Activate := false;
                    WebPortalNotification_lRec.Modify();
                end;
            until TempWebPortalNotification_gRec.Next() = 0;
    end;


}

