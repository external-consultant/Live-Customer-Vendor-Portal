pageextension 81230 "INT B M Role Center" extends "Business Manager Role Center"
{

    actions
    {
        addafter("Purchase Invoice")
        {
            group("INT Customer/Vendor Portal")
            {

                Caption = 'Business Portal';
                Image = CustomerGroup;
                action("INT Request for Portal")
                {
                    ApplicationArea = All;
                    Caption = 'Request for Portal Access';
                    Image = SendConfirmation;
                    RunObject = report "INT Send Service Details";
                    ToolTip = 'Executes the Request for Portal Access action.';
                }
                action("INT Login")
                {
                    ApplicationArea = All;
                    Caption = 'Dashboard Preview';
                    Image = Worksheet;
                    RunObject = report "INT Login Prompt";
                    ToolTip = 'Executes the Dashboard Preview action.';
                }

                group("INT Login Management")
                {
                    Caption = 'Login Management';
                    Image = Lock;
                    action("INT Login List")
                    {
                        ApplicationArea = All;
                        Caption = 'Login List';
                        Image = ListPage;
                        RunObject = page "INT Web Portal-Login List Page";
                        ToolTip = 'Executes the Login List action.';
                    }
                    action("INT Login History")
                    {
                        ApplicationArea = All;
                        Caption = 'Login History';
                        Image = History;
                        RunObject = page "INT - Login History";
                        ToolTip = 'Executes the Login History action.';
                    }
                }
                action("INT Notification Management")
                {
                    ApplicationArea = All;
                    Caption = 'Notification Management';
                    Image = ExportMessage;
                    RunObject = page "INT - Notification(NAV)";
                    ToolTip = 'Executes the Notification Management action.';
                }
                action("INT Check Information")
                {
                    ApplicationArea = All;
                    Caption = 'Check Information';
                    Image = Check;
                    RunObject = page "INT -Check Information List";
                    ToolTip = 'Executes the Check Information action.';
                }
                action("INT Web Portal - Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Web Portal - Setup';
                    Image = Setup;
                    RunObject = page "INT Web Portal Setup";
                    ToolTip = 'Executes the Web Portal - Setup action.';
                }
            }
        }
    }
}


