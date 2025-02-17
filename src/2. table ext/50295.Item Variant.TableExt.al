tableextension 50295 tableextension50295 extends "Item Variant"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Code(Field 1)".

    }

    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    UpdateLastModificationDate("Item No."); //DI.17.05.12
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    UpdateLastModificationDate("Item No."); //DI.17.05.12
    */
    //end;


    //Unsupported feature: Code Insertion on "OnRename".

    //trigger OnRename()
    //begin
    /*
    UpdateLastModificationDate("Item No."); //DI.17.05.12
    */
    //end;

    procedure UpdateLastModificationDate(ItemNo: Code[20])
    var
        Item: Record "27";
    begin
        Item.RESET;
        Item.SETRANGE("No.", ItemNo);
        IF Item.FINDFIRST THEN BEGIN
            Item."Last Date Modified" := TODAY;
            Item.MODIFY;
        END;
    end;
}

