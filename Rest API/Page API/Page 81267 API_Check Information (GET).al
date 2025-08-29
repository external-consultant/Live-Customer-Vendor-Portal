page 81267 "API_Check Information"
{
    // version WebPortal

    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCheckInformation';
    DelayedInsert = true;
    EntityName = 'apiCheckInformation';
    EntityCaption = 'apiCheckInformation';
    EntitySetName = 'apiCheckInformations';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCheckInformations';
    PageType = API;
    SourceTable = "INT -Check Information";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(entryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field(userID; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(loginType; Rec."Login Type")
                {
                    ApplicationArea = All;
                    Caption = 'Login Type';
                    ToolTip = 'Specifies the value of the Login Type field.';
                }
                field(accountNo; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(paymentType; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field(checkNo; Rec."Check No.")
                {
                    ApplicationArea = All;
                    Caption = 'Check No.';
                    ToolTip = 'Specifies the value of the Check No. field.';
                }
                field(checkDate; Rec."Check Date")
                {
                    ApplicationArea = All;
                    Caption = 'Check Date';
                    ToolTip = 'Specifies the value of the Check Date field.';
                }
                field(checkIssueBy; Rec."Check Issue By")
                {
                    ApplicationArea = All;
                    Caption = 'Check Issue By';
                    ToolTip = 'Specifies the value of the Check Issue By field.';
                }
                field(checkReceivedBy; Rec."Check Received By")
                {
                    ApplicationArea = All;
                    Caption = 'Check Received By';
                    ToolTip = 'Specifies the value of the Check Received By field.';
                }
                field(bankName; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Name';
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(bankBranchName; Rec."Bank Branch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Bank Branch Name';
                    ToolTip = 'Specifies the value of the Bank Branch Name field.';
                }
                field(neft_rtgs_ReferenceNo; Rec."NEFT/RTGS Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'NEFT/RTGS Reference No.';
                    ToolTip = 'Specifies the value of the NEFT/RTGS Reference No. field.';
                }
                field(amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Caption = 'Posted';
                    ToolTip = 'Specifies the value of the Posted field.';
                }
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

