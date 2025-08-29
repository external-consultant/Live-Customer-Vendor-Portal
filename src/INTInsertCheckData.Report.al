report 81236 "INT Insert Check Data"
{
    Caption = 'Insert Check Data';
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
                group("Insert Check Information")
                {
                    Caption = 'Insert Check Information';
                    field(PaymentType; PaymentType1)
                    {
                        ApplicationArea = All;
                        Caption = 'PaymentType';
                        OptionCaption = '" ",Check,NEFT,RTGS,CASH';
                        ToolTip = 'Specifies the value of the PaymentType field.';
                    }
                    field(CheckNo; CheckDate1)
                    {
                        ApplicationArea = All;
                        Caption = 'CheckNo';
                        ToolTip = 'Specifies the value of the CheckNo field.';
                    }
                    field(CheckDate; CheckDate1)
                    {
                        ApplicationArea = All;
                        Caption = 'CheckDate';
                        ToolTip = 'Specifies the value of the CheckDate field.';
                    }
                    field(CheckIssueBy; CheckDate1)
                    {
                        ApplicationArea = All;
                        Caption = 'CheckIssueBy';
                        ToolTip = 'Specifies the value of the CheckIssueBy field.';
                    }
                    field(CheckReceivedBy; CheckReceivedBy1)
                    {
                        ApplicationArea = All;
                        Caption = 'CheckReceivedBy';
                        ToolTip = 'Specifies the value of the CheckReceivedBy field.';
                    }
                    field(BankName; BankBranchName1)
                    {
                        ApplicationArea = All;
                        Caption = 'BankName';
                        ToolTip = 'Specifies the value of the BankName field.';
                    }
                    field(BankBranchName; BankBranchName1)
                    {
                        ApplicationArea = All;
                        Caption = 'BankBranchName';
                        ToolTip = 'Specifies the value of the BankBranchName field.';
                    }
                    field(NEFTOrRTGSReferenceNo; NEFTOrRTGSReferenceNo1)
                    {
                        ApplicationArea = All;
                        Caption = 'NEFTOrRTGSReferenceNo';
                        ToolTip = 'Specifies the value of the NEFTOrRTGSReferenceNo field.';
                    }
                    field(AmountDetail; AmountDetail1)
                    {
                        ApplicationArea = All;
                        Caption = 'AmountDetail';
                        ToolTip = 'Specifies the value of the AmountDetail field.';
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
        SingleInstance: Codeunit "INT Single Instance";
        WebPortalCheckMgmt: Codeunit "INT Web Portal - Check Mgmt";
    begin
        Clear(WebPortalCheckMgmt);
        WebPortalCheckMgmt.InsertCheckData_gFnc('Customer', SingleInstance.GetAccountNo(), CopyStr(Format(PaymentType1), 1, 50), CheckNo1, CheckDate1, CheckIssueBy1, CheckReceivedBy1, BankName1, BankBranchName1, NEFTOrRTGSReferenceNo1, AmountDetail1);
    end;

    var
        CheckDate1: Date;
        AmountDetail1: Decimal;
        PaymentType1: Option " ",Check,NEFT,RTGS,CASH;
        CheckNo1: Text[30];
        BankBranchName1: Text[50];
        BankName1: Text[50];
        CheckIssueBy1: Text[50];
        CheckReceivedBy1: Text[50];
        NEFTOrRTGSReferenceNo1: Text[50];
}

