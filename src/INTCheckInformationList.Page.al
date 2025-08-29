page 81257 "INT -Check Information List"
{
    // version WebPortal

    Caption = 'Check Information';
    PageType = List;
    SourceTable = "INT -Check Information";

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
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field("Check No."; Rec."Check No.")
                {
                    ApplicationArea = All;
                    Caption = 'Check No.';
                    ToolTip = 'Specifies the value of the Check No. field.';
                }
                field("Check Date"; Rec."Check Date")
                {
                    ApplicationArea = All;
                    Caption = 'Check Date';
                    ToolTip = 'Specifies the value of the Check Date field.';
                }
                field("Check Issue By"; Rec."Check Issue By")
                {
                    ApplicationArea = All;
                    Caption = 'Check Issue By';
                    ToolTip = 'Specifies the value of the Check Issue By field.';
                }
                field("Check Received By"; Rec."Check Received By")
                {
                    ApplicationArea = All;
                    Caption = 'Check Received By';
                    ToolTip = 'Specifies the value of the Check Received By field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Name';
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Bank Branch Name"; Rec."Bank Branch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Branch Name';
                    ToolTip = 'Specifies the value of the Bank Branch Name field.';
                }
                field("NEFT/RTGS Reference No."; Rec."NEFT/RTGS Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'NEFT/RTGS Reference No.';
                    ToolTip = 'Specifies the value of the NEFT/RTGS Reference No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Caption = 'Posted';
                    ToolTip = 'Specifies the value of the Posted field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add Check Info")
            {
                ApplicationArea = All;
                Caption = 'Add Check Info';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Add Check Info action.';

                trigger OnAction()
                var
                    InsertCheckData: Report "INT Insert Check Data";
                begin
                    Clear(InsertCheckData);
                    InsertCheckData.RunModal();
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

