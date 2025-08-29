report 81235 "INT Login Prompt"
{
    Caption = 'Login';
    // version WebPortal

    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group("Enter Credentials")
                {
                    Caption = 'Enter Credentials';
                    field(UserID; UserName)
                    {
                        ApplicationArea = All;
                        Caption = 'User ID';
                        ToolTip = 'Specifies the value of the User ID field.';
                    }
                    field(Password; Password1)
                    {
                        ApplicationArea = All;
                        Caption = 'Password';
                        ExtendedDatatype = Masked;
                        ToolTip = 'Specifies the value of the Password field.';
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
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        INTKeyValidationMgt: Codeunit "IKV Mgt";
        WebPortalLoginMgmt: Codeunit "INT Web Portal - Login Mgmt";
        CustomerDashboard: Page "INT Customer Dashboard";
        VendorDashboard: Page "INT Vendor Dashboard";
        AccountNo: Code[20];
        LoginType: Text[10];
        AccountName: Text[50];
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        Clear(WebPortalLoginMgmt);
        WebPortalLoginMgmt.Login_gFnc(UserName, Password1, LoginType, AccountNo, AccountName);

        Clear(SingleInstance);
        SingleInstance.SaveLogin(AccountNo, UserName);

        if LoginType = 'Customer' then begin
            Customer.Reset();
            Customer.SetRange("No.", AccountNo);
            Clear(CustomerDashboard);
            CustomerDashboard.SetTableView(Customer);
            CustomerDashboard.Run();
        end else begin
            Vendor.Reset();
            Vendor.SetRange("No.", AccountNo);
            Clear(VendorDashboard);
            VendorDashboard.SetTableView(Vendor);
            VendorDashboard.Run();
        end;
    end;

    var
        SingleInstance: Codeunit "INT Single Instance";
        UserName: Code[80];
        Password1: Text[20];
}

