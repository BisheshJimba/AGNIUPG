table 25006211 "Mob. Offl. Signature"
{
    // 
    // 02.05.2017 EB.P7
    //   Created


    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; Description; Text[50])
        {
        }
        field(30; Signature; BLOB)
        {
            SubType = Bitmap;
        }
        field(40; SignatureCodeBase64; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

