codeunit 81231 "INT Install Code"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        INTWebPortalSetup: Record "INT Web Portal - Setup";
        INTKeyValidationMgt: Codeunit "IKV Mgt";
        INTWebServiceCreate: Codeunit "INT Web Portal -Create WebServ";
    begin

        if INTWebPortalSetup.IsEmpty() then begin
            INTWebPortalSetup.Init();
            INTWebPortalSetup.Insert();
            INTWebPortalSetup."Activation Key" := INTKeyValidationMgt.GetKey(30);
            INTWebPortalSetup.Modify();
        end;

        Clear(INTWebServiceCreate);
        INTWebServiceCreate.Create();

        // User_Local.Init();
        // User_Local.Validate("User Security ID", CreateGuid());
        // User_Local.Validate("User Name", 'BC');
        // User_Local.Validate("Full Name", 'Business Portal User');
        // User_Local.Validate("License Type", User_Local."License Type"::"Full User");
        // User_Local.Insert(true);

        // User_Local.Reset();
        // User_Local.SetRange("User Name", 'BC');
        // User_Local.FindFirst();

        // AccessControl.Init();
        // AccessControl.Validate("User Security ID", User_Local."User Security ID");
        // AccessControl.Insert(true);
    end;
}