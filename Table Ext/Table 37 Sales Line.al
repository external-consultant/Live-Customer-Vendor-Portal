tableextension 81231 SalesLine extends "Sales Line"
{
    fields
    {
        field(92745; StatusfromSalesHeader; Enum "Sales Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header".Status where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}