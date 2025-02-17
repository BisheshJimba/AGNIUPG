tableextension 50174 tableextension50174 extends "Detailed Vendor Ledg. Entry"
{
    keys
    {
        key(Key1; "Initial Entry Global Dim. 1", "Vendor No.", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key2; "Initial Entry Global Dim. 2", "Vendor No.", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key3; "Initial Entry Global Dim. 2", "Initial Entry Global Dim. 1", "Vendor No.", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }
}

