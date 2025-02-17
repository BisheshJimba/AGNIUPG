tableextension 50269 tableextension50269 extends "Human Resource Comment Line"
{
    fields
    {
        modify("Table Name")
        {
            OptionCaption = 'Employee,Alternative Address,Employee Qualification,Employee Relative,Employee Absence,Misc. Article Information,Confidential Information,Application,Interview';

            //Unsupported feature: Property Modification (OptionString) on ""Table Name"(Field 1)".

        }
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Employee)) Employee.No.
                            ELSE IF (Table Name=CONST(Alternative Address)) "Alternative Address"."Employee No."
                            ELSE IF (Table Name=CONST(Employee Qualification)) "Employee Qualification".No.
                            ELSE IF (Table Name=CONST(Misc. Article Information)) "Misc. Article Information"."Employee No."
                            ELSE IF (Table Name=CONST(Confidential Information)) "Confidential Information"."Employee No."
                            ELSE IF (Table Name=CONST(Employee Absence)) "Employee Absence"."Employee No."
                            ELSE IF (Table Name=CONST(Employee Relative)) "Employee Relative"."Employee No."
                            ELSE IF (Table Name=CONST(Application)) Application.No.
                            ELSE IF (Table Name=CONST(Interview)) "Application Interview Details"."Application No.";
        }
    }
}

