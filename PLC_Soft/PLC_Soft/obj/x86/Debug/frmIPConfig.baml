   M S B A M L   `   `   `  ����a  ]PresentationFramework.Luna, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35gJclr-namespace:Microsoft.Windows.Themes;assembly=PresentationFramework.LunaMicrosoft.Windows.Themes  5   	   C ?PLC_Soft, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null9!clr-namespace:PLC_Soft.PropertiesPLC_Soft.Properties 5         PLC_Soft.frmIPConfig   5   	   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   YmyJclr-namespace:Microsoft.Windows.Themes;assembly=PresentationFramework.Luna     5   	   8
properties!clr-namespace:PLC_Soft.Properties     5        � Title$  	IP Config��5   	   $	��186��6   $	��361��6(    � 
ResizeMode$ NoResize=�64   $��Tahoma)�5      $��13(�5       � Icon$< 6/PLC_Soft;component/Images/network-connection-icon.png��6   .��5	      �  � ColumnDefinitions 5
   
   �� 5      $
��0.5* �6   �� 5      $
��0.5* �6    � RowDefinitions 5   
   �� 5      $��* �6   �� 5      $��* �6   �� 5      $��* �6   �� 5      $��* �6   .+�5   
   �� $��Domain Address��6   $��28��5      $
��Left=�5      $��5q�5      $	��Top=�5      �� 5   
   $��Master Address��6   $��1��5      $��28��5      $
��Left=�5      $��5q�5      $	��Top=�5      �� 5   
   $��
IP Address��6   $��2��5       $��28��5!      $
��Left=�5"      $��5q�5#      $	��Top=�5$      �� 5%   
   -   5        $��btnSave��5,      $
��Save��5%      $��3��5&      $��23��5'      $��Right=�5(      $��5q�5)      $	��Top=�5*      $��75��5+      5,       �� 5-   
   -   5        $��	btnCancel��53      $��Cancel��5-      $��1��5.      $��3��5/      $��23��50      $
��Left=�51      $��5q�52      $	��Top=�54      $��75��55      6   �� 56   
   -   5        $��txtDomainAdd��5:      $��1��56      $��23��57      $
��Left=�58      $��5q�59      $	��Top=�5<      $	��150��5=      ��5;      �� " PLC_Soft.Properties.Settings   Default �� Source# Z  �� Path$ DomainAddress�5=      �� 5>   
   -   5        $��txtMasterAdd��5C      $��1��5>      $��1��5?      $��23��5@      $
��Left=�5A      $��5q�5B      $	��Top=�5E      $	��150��5F      ��5D      �� # Z $ MasterAddress�5F      �� 5G   
   -   5        $��txtIPAdd��5L      $��1��5G      $��2��5H      $��23��5I      $
��Left=�5J      $��5q�5K      $	��Top=�5N      $	��150��5O      ��5M      �� # Z $ 	IPAddress�5O      5P      5Q      