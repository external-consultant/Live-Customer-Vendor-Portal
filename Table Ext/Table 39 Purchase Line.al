tableextension 81230 Purchaseline extends "Purchase Line"
{
    fields
    {
        field(92745; Statusfrompurchaseheader; Enum "Purchase Document Status")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(92746; "Vendor Ship Qty."; Decimal)
        {
            Description = 'T13751';
            DataClassification = ToBeClassified;
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