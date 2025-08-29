page 81240 "INT - Login History"
{
    // version WebPortal,ForNAVOnly

    Caption = 'Login History';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "INT - Login History";
    SourceTableView = sorting("Entry No.")
                      order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
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
                field("Login DateTime"; Rec."Login DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'Login DateTime';
                    ToolTip = 'Specifies the value of the Login DateTime field.';
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
            }
        }
    }

    actions
    {
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

