page 81246 "INT Web Portal Setup"
{
    // version WebPortal

    Caption = 'Web Portal Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "INT Web Portal - Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("Email as CC for Cust/Vend"; Rec."Email as CC for Cust/Vend")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Email as CC for Customer/Vendor';
                //     ToolTip = 'Specifies the value of the Email as CC for Customer/Vendor field.';
                // }
                // field("Business Portal URL"; Rec."Business Portal URL")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Business Portal URL';
                //     ToolTip = 'Specifies the value of the Business Portal URL field.';
                // }
                field("Customer Portal URL"; Rec."Customer Portal URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Portal URL field.';
                }
                field("Vendor Portal URL"; Rec."Vendor Portal URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Portal URL field.';
                }

            }
            group("App Activation")
            {
                Caption = 'App Activation';
                field("Activation Key"; Rec."Activation Key")
                {
                    ApplicationArea = All;
                    Caption = 'Activation Key';
                    ToolTip = 'Specifies the value of the Activation Key field.';
                }
                field("Expiration Date"; ExpirationDate)
                {
                    ApplicationArea = All;
                    Caption = 'ExpirationDate';
                    Editable = false;
                    ToolTip = 'Specifies the value of the ExpirationDate field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action("Age Details")
                {
                    Caption = 'Age Details';
                    ApplicationArea = All;
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = page WebportalAgeDetails;
                }
                // action("Generate Web Services")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Generate Web Services';
                //     Image = CreateXMLFile;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ToolTip = 'Executes the Generate Web Services action.';

                //     trigger OnAction()
                //     var
                //         CU: Codeunit "INT Web Portal -Create WebServ";
                //     begin
                //         Clear(CU);
                //         CU.Run();
                //     end;
                // }
                group("Login Management")
                {
                    Caption = 'Login Management';
                    action("Login List")
                    {
                        ApplicationArea = All;
                        Caption = 'Login List';
                        Image = ListPage;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = page "INT Web Portal-Login List Page";
                        ToolTip = 'Executes the Login List action.';
                    }
                    action("Login History")
                    {
                        ApplicationArea = All;
                        Caption = 'Login History';
                        Image = History;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        RunObject = page "INT - Login History";
                        ToolTip = 'Executes the Login History action.';
                    }
                }
                // action("Request for Portal")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Request for Portal Access';
                //     Image = SendConfirmation;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     RunObject = report "INT Send Service Details";
                //     ToolTip = 'Executes the Request for Portal Access action.';
                // }
                action("Activate App")
                {
                    ApplicationArea = All;
                    Caption = 'Activate App';
                    Image = Lock;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = report "INT Activate App";
                    ToolTip = 'Executes the Activate App action.';
                }
            }
        }
    }
    var
        ExpirationDate: Date;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();

            // INTComplainHeader.RESET();
            // INTComplainLine.RESET();

            // IF (INTComplainHeader.ISEMPTY()) AND (INTComplainLine.ISEMPTY()) THEN BEGIN
            //     "Activation Key" := INTKeyValidationMgt.GetKey(30);
            //     MODIFY();
            // END;
        end;

        if Rec."Activation Key" <> '' then
            ExpirationDate := INTKeyValidationMgt.ValidateEndDateFunction(Rec."Activation Key");
    end;
}

