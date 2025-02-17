pageextension 50102 pageextension50102 extends "General Journal Batches"
{
    var
        SysMgt: Codeunit "50000";
        "filter": Text;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: SysMgt)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GenJnlManagement.OpenJnlBatch(Rec);
    ShowAllowPaymentExportForPaymentTemplate;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GenJnlManagement.OpenJnlBatch(Rec);
    ShowAllowPaymentExportForPaymentTemplate;

    {
    filter := SysMgt.TemplateSecurityFilterBatch(Rec."Journal Template Name");
    IF filter <> '' THEN
     SETRANGE(Name,filter);
     }
    */
    //end;
}

