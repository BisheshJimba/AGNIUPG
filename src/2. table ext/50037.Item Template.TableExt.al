tableextension 50037 tableextension50037 extends "Item Template"
{
    // 08.02.2017 EB.P7 EDMS Upgrade 2017
    //   Added fields:
    //     25006670Item Type
    //   Modified function CreateFieldRefArray
    fields
    {
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
    }


    //Unsupported feature: Code Modification on "CreateFieldRefArray(PROCEDURE 12)".

    //procedure CreateFieldRefArray();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    I := 1;

    AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(Type)));
    #4..16
    AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Warehouse Class Code")));
    AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Item Category Code")));
    AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Service Item Group")));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19
    //08.02.2017 EB.P7 EDMS Upgrade 2017 >>
    AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Item Type")));
    //08.02.2017 EB.P7 EDMS Upgrade 2017 <<
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateItemFromTemplate(PROCEDURE 8)".

    //procedure UpdateItemFromTemplate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF GUIALLOWED THEN BEGIN
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
      ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
      ConfigTemplates.LOOKUPMODE(TRUE);
      IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
    #7..10
        ItemRecRef.SETTABLE(Item);
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF GUIALLOWED THEN BEGIN
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
      //ConfigTemplateHeader.SETRANGE(Enabled,TRUE); Agni UPG 2009
    #4..13
    */
    //end;
}

