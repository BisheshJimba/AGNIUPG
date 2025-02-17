codeunit 33019886 InsertScrapBattery
{
    TableNo = 27;

    trigger OnRun()
    begin

        /*
         ScrapItem.COPY(Rec);
        ScrapItem.SETRANGE("No.","No.");
        ScrapItem.SETRANGE("Scrap No.",TRUE);
        IF ScrapItem.FIND('-') THEN
            MESSAGE('1234546');
           {
         ScrapItem."No." := INSSTR("No.",'-S',99);
           ScrapItem.Description := Description;
           ScrapItem."Item Category Code" := "Item Category Code";
           ScrapItem."Product Group Code" := "Product Group Code";
           ScrapItem."Product Subgroup Code" := "Product Subgroup Code";
           ScrapItem."Item For" := "Item For";
           }
       ScrapItem.INIT;
       ScrapItem.TRANSFERFIELDS(Rec);
       ScrapItem."No." := INSSTR("No.",'-S',99);
       ScrapItem."Scrap No." := TRUE;
       ScrapItem.INSERT;
        */

    end;

    var
        ScrapItem: Record "27";
}

