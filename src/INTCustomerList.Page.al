page 81250 "INT - Customer List"
{
    // version WebPortal

    Caption = 'Customer Details';
    PageType = List;
    SourceTable = Customer;
    SourceTableView = sorting("No.")
                      where("Salesperson Code" = filter(<> ''));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the customer''s name.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the customer''s city.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Code';
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;
}

