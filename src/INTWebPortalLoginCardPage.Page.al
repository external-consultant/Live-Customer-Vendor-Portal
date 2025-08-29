page 81231 "INT Web Portal-Login Card Page"
{
    // version WebPortal,ForNAVOnly

    Caption = 'Login Card';
    PageType = Card;
    SourceTable = "INT - Login Table";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("User ID (E-Mail)"; Rec."User ID (E-Mail)")
                {
                    ApplicationArea = All;
                    Caption = 'User ID (E-Mail)';
                    ToolTip = 'Specifies the value of the User ID (E-Mail) field.';
                    trigger OnValidate()
                    var
                        CheckEmail: Codeunit "Mail Management";
                    begin
                        CheckEmail.CheckValidEmailAddress(Rec."User ID (E-Mail)");
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = all;
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
                field("Customer Name"; CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'CustomerName';
                    ToolTip = 'Specifies the value of the CustomerName field.';
                }
                field("Vendor Name"; VendorName)
                {
                    ApplicationArea = All;
                    Caption = 'VendorName';
                    ToolTip = 'Specifies the value of the VendorName field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Caption = 'Blocked';
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field("Blocked By"; Rec."Blocked By")
                {
                    ApplicationArea = All;
                    Caption = 'Blocked By';
                    ToolTip = 'Specifies the value of the Blocked By field.';
                }
                field("Blocked Date Time"; Rec."Blocked Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Blocked Date Time';
                    ToolTip = 'Specifies the value of the Blocked Date Time field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Email Login Details")
            {
                ApplicationArea = All;
                Caption = 'Email Login Details';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Email Login Details action.';

                trigger OnAction()
                begin
                    Rec.SendLoginDetails();
                end;
            }
            action("Change Password Check")
            {
                ApplicationArea = All;
                Caption = 'Change Password Check';
                Image = TestDatabase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Change Password Check action.';
                Visible = false;

                trigger OnAction()
                var
                    CU: Codeunit "INT Web Portal - Login Mgmt";
                begin
                    CU.RegeneratePassword_gFnc('nishit@intech-systems.com', '964F95E7818F46E1A77D', '123');
                end;
            }

        }
    }
    var
        CustomerName: Text[100];
        VendorName: Text[100];

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        CustomerName := '';
        VendorName := '';
        if Rec."Login Type" = Rec."Login Type"::Customer then begin
            Clear(Customer);
            Customer.Get(Rec."Account No.");
            CustomerName := Customer.Name;
        end else begin
            Clear(Vendor);
            Vendor.Get(Rec."Account No.");
            VendorName := Vendor.Name;
        end;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

