page 81230 "INT Web Portal-Login List Page"
{
    // version WebPortal,ForNAVOnly

    Caption = 'Web Portal Login List';
    CardPageId = "INT Web Portal-Login Card Page";
    PageType = List;
    SourceTable = "INT - Login Table";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("User ID (E-Mail)"; Rec."User ID (E-Mail)")
                {
                    ApplicationArea = All;
                    Caption = 'User ID (E-Mail)';
                    ToolTip = 'Specifies the value of the User ID (E-Mail) field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    Caption = 'Password';
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
        }
        area(Navigation)
        {
            action("Test Report Prints")
            {
                ApplicationArea = All;
                Caption = 'Test Report Prints';
                Image = TestFile;
                ToolTip = 'Executes the Test Report Prints action.';
                Visible = true;

                trigger OnAction()
                var
                    CU: Codeunit "INT Web Portal Report (Email)";
                begin
                    Clear(CU);
                    // CU.PrintPostedSalesInvoice_gFnc('PS-INV103004', 'nishit@intech-systems.com');
                    // CU.PrintPostedSalesCreditNote_gFnc('PS-CR104001', 'nishit@intech-systems.com');
                    // CU.PrintSalesOrder_gFnc('S-ORD101004', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchDebitNote_gFnc('109001', 'nishit@intech-systems.com');
                    // CU.PrintPurchaseOrder_gFnc('106001', 'nishit@intech-systems.com');
                    CU.PrintCustomerStatement_gFnc('10000', '01-01-2012', '01-09-2020', 'nishit@intech-systems.com');
                    // CU.PrintCustomerStatementExcel_gFnc('50000', 20120101D, Today(), 'nishit@intech-systems.com');
                    // CU.PrintVendorStatement_gFnc('50000', 20120101D, Today(), 'nishit@intech-systems.com');
                    // CU.PrintPendingSalesInvoice_gFnc('S-INV102205', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchInvoice_gFnc('108005', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchRcpt_gFnc('107005', 'nishit@intech-systems.com');
                    //CU.PrintCustomerPayments_gFnc('PS-INV103006', 'nishit@intech-systems.com');
                    // CU.PrintVendorPayments_gFnc('108002', 'nishit@intech-systems.com');
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
            if Rec."Account No." <> '' then begin
                Customer.Get(Rec."Account No.");
                CustomerName := Customer.Name;
            end;
        end else
            if Rec."Login Type" = Rec."Login Type"::Vendor then begin
                Clear(Vendor);
                if Rec."Account No." <> '' then begin
                    Vendor.Get(Rec."Account No.");
                    VendorName := Vendor.Name;
                end;
            end;
    end;

    // trigger OnOpenPage()
    // var
    //     INTKeyValidationMgt: Codeunit "IKV Mgt";
    // begin
    //     Clear(INTKeyValidationMgt);
    //     INTKeyValidationMgt.onOpenPageKeyValidation();
    // end;
}

