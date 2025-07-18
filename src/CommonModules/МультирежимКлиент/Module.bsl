
#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьПраваИлиПользователей(Форма, ОповещениеОЗавершении) Экспорт
	
	ЭтоЛичныеНастройки = МультирежимКлиентСервер.ПоказыватьЛичныеНастройки(Форма);
	Если ЭтоЛичныеНастройки Тогда
		ОткрытьПраваПользователя(Форма, ОповещениеОЗавершении);
	Иначе
		ОткрытьПраваПользователей(Форма, ОповещениеОЗавершении); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьПраваПользователя(Форма, ОповещениеОЗавершении) Экспорт
		
	Если Форма.ВладелецЭЦПРасширилСебеПрава Тогда
		
		ЭтоДобавлениеПользователя = МультирежимКлиентСервер.ЭтоДобавлениеПользователяПоСотруднику(Форма, Форма.ВладелецЭЦП);
		
		Если ЭтоДобавлениеПользователя Тогда
			Текст = НСтр("ru = 'Вы не можете сменить роль поскольку администратор не предоставил вам доступ к учетной записи';
						|en = 'Вы не можете сменить роль поскольку администратор не предоставил вам доступ к учетной записи'");
		Иначе
			Текст = НСтр("ru = 'Ваша новая роль - Администратор';
						|en = 'Ваша новая роль - Администратор'");
		КонецЕсли;
		ПоказатьПредупреждение(, Текст);
		Возврат;
	КонецЕсли;
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(Форма, Форма.ВладелецЭЦП, Истина, Истина);
	Если Строка = Неопределено Тогда
		Пользователь = МультирежимВызовСервера.ПользовательПоФизЛицуИзСправочникаПользователи(Форма.ВладелецЭЦП);
	Иначе
		Пользователь = Строка.Пользователь;
	КонецЕсли;
	
	РедактироватьПользователя(Форма, Пользователь, ОповещениеОЗавершении, Истина);
	
КонецПроцедуры

Процедура ОткрытьПраваПользователей(Форма, ОповещениеОЗавершении = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ПараметрыФормы = Форма.ПараметрыФормыПользователи();
	ПараметрыФормы.Вставить("ОткрытоИзЗаявления", ОбработкаЗаявленийАбонентаКлиентСервер.ЭтоФормаЗаявления(Форма));
	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьПраваПользователей_Завершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	ОткрытьФорму(
		Форма.КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ПользователиУчетнойЗаписи", 
		ПараметрыФормы, 
		Форма,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры
	
Процедура ОткрытьПраваПользователей_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ Результат.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ВходящийКонтекст.Форма;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(Форма);
	
	ЗаполнитьЗначенияСвойств(Форма, Результат.ВсеГосОрганыУчетнойЗаписи);
	ЗаполнитьЗначенияСвойств(Форма, Результат, Результат.ПараметрыФормы);
	
	Форма.ТаблицаИзАдреса(Результат.ВсеГосОрганыУчетнойЗаписи.АдресПолучателейФНС, "ПолучателиФНС");
	Форма.ТаблицаИзАдреса(Результат.ВсеГосОрганыУчетнойЗаписи.АдресПолучателейФСГС, "ПолучателиФСГС");
	Форма.ТаблицаИзАдреса(Результат.АдресТаблицы, "ТаблицаПользователей");
	
	Если Форма.ЭтоМультиРежим Тогда
		Форма.ТарифОператораЭДО = Неопределено;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении);
	
КонецПроцедуры

Процедура ОбновитьСНИЛСФизЛица(Форма, ФизическоеЛицо) Экспорт
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(Форма, ФизическоеЛицо);
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка.СНИЛС = МультирежимВызовСервера.СНИЛСФизЛица(Строка.ФизическоеЛицо, Форма.Организация);
	
КонецПроцедуры

Процедура РедактироватьПользователя(Форма, Пользователь, ОповещениеОЗавершении, ЭтоВызовИзГлавногоОкна) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ПараметрыОткрытия = Форма.ПараметрыФормыПравПользователя();
	ПараметрыОткрытия.Вставить("Пользователь", Пользователь);
	ПараметрыОткрытия.Вставить("ЭтоВызовИзГлавногоОкна", ЭтоВызовИзГлавногоОкна);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РедактироватьПользователя_Завершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ОткрытьФорму(
		Форма.КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ПраваПользователя",
		ПараметрыОткрытия,
		ЭтотОбъект,
		,
		,
		,
		ОписаниеОповещения, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры
	
Процедура РедактироватьПользователя_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ Результат.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ВходящийКонтекст.Форма;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(Форма);
	
	Форма.ТаблицаИзАдреса(Результат.АдресТаблицы, "ТаблицаПользователей");
	Форма.ВладелецЭЦПРасширилСебеПрава = Результат.ВладелецЭЦПРасширилСебеПрава;
	
	Если Результат.ЭтоВызовИзГлавногоОкна Тогда
		ОбновитьРольВладельцаЭЦП(Форма);
	Иначе
		Форма.ВсеГосОрганыУчетнойЗаписи = Результат.ВсеГосОрганыУчетнойЗаписи;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении);
	
КонецПроцедуры

Процедура ОбновитьРольВладельцаЭЦП(Форма) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Форма.ВладелецЭЦП) Тогда
		Возврат;
	КонецЕсли;
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(Форма, Форма.ВладелецЭЦП, Истина);
	Форма.ВладелецЭЦПЭтоАдмин = Строка.ЭтоАдмин;
	
КонецПроцедуры

Процедура ПоказатьШифровальщиков(Форма, ОповещениеОЗавершении = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ПараметрыФормы = Форма.ПараметрыФормыШифровальщики();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьШифровальщиков_Завершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ОткрытьФорму(
		Форма.КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ШифровальщикиФНС", 
		ПараметрыФормы,
		,,,,
		ОписаниеОповещения);
	
КонецПроцедуры
	
Процедура ПоказатьШифровальщиков_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено ИЛИ НЕ Результат.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ВходящийКонтекст.Форма;
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(Форма);
	
	Форма.СкопироватьШифровальщиков(Результат.АдресТаблицы); 
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении);
	
КонецПроцедуры

Процедура ПоказатьПриглашениеПользователя(ТекущийПользователь) Экспорт
	
	ОтключитьОбработчикОжидания("ПоказатьПриглашенияПользователям");
	
	Данные  = МультирежимВызовСервера.ДанныеПриглашенияПользователяИзРегистра(ТекущийПользователь);
	Открыта = ОбработкаЗаявленийАбонентаКлиент.ФормаОповещенияИлиМастераУжеОткрыта();
	
	ПропуститьПоказПриглашения = Данные.Количество() = 0 ИЛИ Открыта;
	
	Если ПропуститьПоказПриглашения Тогда
		ПоказатьПриглашениеПользователя_ПодключитьПовторно();
	Иначе
		Для каждого Строка Из Данные Цикл
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПоказатьПриглашениеПользователя_ОткрытьМастер", 
				ЭтотОбъект, 
				Строка);
				
			ДополнительныеПараметры = Новый Структура();
			ДополнительныеПараметры.Вставить("ПараметрыФормы", Строка);
			
			ОткрытьФорму(
				"Документ.ЗаявлениеАбонентаСпецоператораСвязи.Форма.ПриглашениеПользователя", 
				ДополнительныеПараметры,
				,
				Строка,
				,
				,
				ОписаниеОповещения);
		
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьПриглашениеПользователя_ПодключитьПовторно() Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	ЕстьПравоНаДО = ПараметрыРаботыКлиентаПриЗапуске.ДокументооборотСКонтролирующимиОрганами_ЕстьПравоНаДОсКОПриЗапуске;
	
	Если ЕстьПравоНаДО Тогда
		
		ЭтоТестирование = ДокументооборотСКОКлиент.ИспользуетсяРежимТестирования();
		Если ЭтоТестирование Тогда
			Интервал = 10;
		Иначе
			Интервал = 10*60*60;
		КонецЕсли;
		
		ПодключитьПоказПриглашенийПользователя(Интервал);
		
	КонецЕсли;

КонецПроцедуры

Процедура ПодключитьПоказПриглашенийПользователя(Интервал) Экспорт
	
	ПодключитьОбработчикОжидания("ПоказатьПриглашенияПользователям", Интервал, Истина);
	
КонецПроцедуры

Процедура ПоказатьПриглашениеПользователя_ОткрытьМастер(Результат, ВходящийКонтекст) Экспорт
	
	ПоказатьПриглашениеПользователя_ПодключитьПовторно(); // Все равно подключаем не зависимо от ответа
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
		ВходящийКонтекст.Организация, 
		,
		,
		ПредопределенноеЗначение("Перечисление.ТипыЗаявленияАбонентаСпецоператораСвязи.Первичное"));
	
КонецПроцедуры

Процедура ПоказатьАдминистраторов(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Админы = МультирежимКлиентСервер.ПодключенныеАдминистраторыПоТаблице(Форма, Ложь);
	
	ПоказатьЗначения(Админы, НСтр("ru = 'Администраторы:';
									|en = 'Администраторы:'"));
	
КонецПроцедуры

Процедура ПоказатьЗначения(Значения, Заголовок) Экспорт
	
	ЗначенияСтрокой = Новый Массив;
	Для каждого Значение Из Значения Цикл
		ЗначенияСтрокой.Добавить("- " + Строка(Значение));
	КонецЦикла;
	
	Текст = СтрСоединить(ЗначенияСтрокой, Символы.ПС);
	
	ПоказатьПредупреждение(, Текст,, Заголовок);
	
КонецПроцедуры

Процедура ПредупредитьОНеобходимостиСменитьПользователя(Форма, РезультатПроверки, ТекстОшибки = "") Экспорт
	
	Если ТекстОшибки = "" Тогда
		
		ТекстОшибки = НСтр("ru = 'Вы можете подавать заявление на многопользовательский режим только войдя под пользователем %1. 
                            |
                            |Подать заявление от лица %2 может только пользователь %3.
                            |';
                            |en = 'Вы можете подавать заявление на многопользовательский режим только войдя под пользователем %1. 
                            |
                            |Подать заявление от лица %2 может только пользователь %3.
                            |'");
		
		Если МультирежимКлиентСервер.ЭтоПодключениеМультирежима(Форма) Тогда
			
			ТекстОшибки = ТекстОшибки + Символы.ПС 
				+ НСтр("ru = 'Смените владельца эл. подписи в заявлении на %1 или попросите отправить заявление сотрудника %2.';
						|en = 'Смените владельца эл. подписи в заявлении на %1 или попросите отправить заявление сотрудника %2.'");
				
		КонецЕсли;
		
		ТекстОшибки = СтрШаблон(ТекстОшибки, 
			РезультатПроверки.ПравильныйВладелецЭЦП, 
			РезультатПроверки.НовоеФизЛицо, 
			РезультатПроверки.ИмяНовогоПользователя);
			
	КонецЕсли;
		
	Кнопки = Новый СписокЗначений;
	
	ЭтоТестирование = ДокументооборотСКОКлиент.ИспользуетсяРежимТестирования();
	
	Если ЭтоТестирование Тогда
		
		Кнопки.Добавить(НСтр("ru = 'Войти под пользователем ';
							|en = 'Войти под пользователем '") + Строка(РезультатПроверки.ИмяНовогоПользователя));
		Кнопки.Добавить(НСтр("ru = 'Отмена';
							|en = 'Отмена'"));
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Кнопки", Кнопки);
		ДополнительныеПараметры.Вставить("РезультатПроверки", РезультатПроверки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПредупредитьОНеобходимостиСменитьПользователя_ПослеВопроса", 
			ЭтотОбъект, 
			ДополнительныеПараметры);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстОшибки, Кнопки,,Кнопки[0].Значение);
		
	Иначе
		
		ПоказатьПредупреждение(, ТекстОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредупредитьОНеобходимостиСменитьПользователя_ПослеВопроса(Ответ, ВходящийКонтекст) Экспорт
	
	Кнопки = ВходящийКонтекст.Кнопки;
	РезультатПроверки = ВходящийКонтекст.РезультатПроверки;
	
	Если Ответ = Кнопки[0].Значение Тогда
		
		ЗавершитьРаботуСистемы(Истина, Истина,"/N " + РезультатПроверки.ИмяНовогоПользователя);
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьПредупреждениеОбратитесьКАдминистратору(Форма, Действие, ОповещениеОЗавершении) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	ПараметрыФормы = Форма.ПараметрыПредупрежденияОбратитесьКАдминистратору();
	ПараметрыФормы.Вставить("Действие", Действие);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьПредупреждениеОбратитесьКАдминистратору_Завершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	ОткрытьФорму(
		Форма.КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ОбратитесьКАдминистратору", 
		ПараметрыФормы, 
		Форма,
		,
		,
		,
		ОписаниеОповещения);
	
КонецПроцедуры
	
Процедура ПоказатьПредупреждениеОбратитесьКАдминистратору_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено ТОгда
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении);
		Возврат;
	КОнецЕсли;
	
	Форма = ВходящийКонтекст.Форма;
	
	Форма.ТаблицаИзАдреса(Результат.АдресТаблицы, "ТаблицаПользователей");
	ЗаполнитьЗначенияСвойств(Форма, Результат); 

	РасширитьПрава = Истина;
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РасширитьПрава);
	
КонецПроцедуры

Процедура ПоказатьОшибкуОтключенияЕдинственногоАдмина(КонтекстЭДОКлиент) Экспорт

	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ОшибкаОтключениеЕдинственногоАдмина");

КонецПроцедуры

#КонецОбласти