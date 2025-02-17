page 33020190 "Pending Insurance List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020164;
    SourceTableView = WHERE(Insurance Memo Exists=FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reference No.";"Reference No.")
                {
                }
                field("Chasis No.";"Chasis No.")
                {
                }
                field("ARE1 No.";"ARE1 No.")
                {
                }
                field("Engine No.";"Engine No.")
                {
                }
                field(Model;Model)
                {
                }
                field("Model Name";"Model Name")
                {
                }
                field("Model Version";"Model Version")
                {
                }
                field("Model Version Desc.";"Model Version Desc.")
                {
                }
                field("Veh. Reg No.";"Veh. Reg No.")
                {
                }
                field("C & F Date";"C & F Date")
                {
                }
                field("C & F Date (BS)";"C & F Date (BS)")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("PP No.";"PP No.")
                {
                }
                field("PP Date";"PP Date")
                {
                }
                field("INS Memo No.";"INS Memo No.")
                {
                }
                field("INS Memo Date";"INS Memo Date")
                {
                }
                field("INS Memo Date (BS)";"INS Memo Date (BS)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //CALCFIELDS("INS Memo No.","INS Memo Date","INS Memo Date (BS)");
    end;
}

