tableextension 81232 Vendor_Ext extends Vendor
{
    fields
    {
        field(81230; "Outstanding Rel Order (LCY)"; Decimal)
        {
            Caption = 'Outstanding Released Order (LCY)';
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = CONST(Order),
                                                                          "Pay-to Vendor No." = FIELD("No."),
                                                                          "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter"),
                                                                          Statusfrompurchaseheader = filter('Released')));
            Editable = false;
            FieldClass = FlowField;
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