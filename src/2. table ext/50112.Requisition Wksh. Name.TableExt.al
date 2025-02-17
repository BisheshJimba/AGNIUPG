tableextension 50112 tableextension50112 extends "Requisition Wksh. Name"
{
    // 24.04.2013 EDMS P8
    //   * Added field: 'Document Profile'
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade";
        }
    }
}

