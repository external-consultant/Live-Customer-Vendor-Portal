//T13751-NS
table 81248 API_PurchHeaderDetailUpdate
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(pk; "Entry No")
        {
            Clustered = true;
        }
    }
}
//T13751-NE