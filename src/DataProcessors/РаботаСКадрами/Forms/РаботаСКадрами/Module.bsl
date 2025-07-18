#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Организация") Тогда
		ЗначенияДляЗаполнения  = Новый Структура("Организация", "Организация");	
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = ЗарплатаКадры.ПерваяДоступнаяОрганизация();
		КонецЕсли; 
	Иначе
		Организация = Параметры.Организация;
	КонецЕсли;
	
	СохраненныйСотрудник = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РаботаСКадрами", "Сотрудник");
	Если СохраненныйСотрудник = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	Сотрудники.Ссылка
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники
			|
			|УПОРЯДОЧИТЬ ПО
			|	Сотрудники.Наименование";
			
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Сотрудник = Выборка.Ссылка;
		КонецЕсли; 
	Иначе
		Сотрудник = СохраненныйСотрудник;
	КонецЕсли; 
	
	ЗарплатаКадрыРасширенный.ИсключитьЗапрещенныеКПроведениюДокументыВДинамическомСпискеЖурналаДокументов(КадровыеПриказыНеПроведенные);
	КадровыйУчетФормыРасширенный.УстановитьУсловноеОформлениеСпискаСБронированиемПозиций(ЭтотОбъект, "КадровыеПриказыНеПроведенные");
	
	УстановитьОтборЖурналовПоОрганизации();
	
	ПрочитатьДанныеСотрудника();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СотрудникиСОшибками, "ТекущаяДата", ТекущаяДатаСеанса(), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	НачатьЗакрытиеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеДанныхФизическогоЛица" 
		И (Источник = ФизическоеЛицо ИЛИ Источник = Сотрудник) Тогда
		
		ПрочитатьДанныеСотрудника();
		
	ИначеЕсли ИмяСобытия = "ИзменениеДанныхМестаРаботы" 
		ИЛИ ИмяСобытия = "ДокументДоговорРаботыУслугиПослеЗаписи"
		ИЛИ ИмяСобытия = "ДокументДоговорАвторскогоЗаказаПослеЗаписи"
		ИЛИ ИмяСобытия = "ДокументНачальнаяШтатнаяРасстановкаПослеЗаписи" Тогда
		
		ОбновитьСписки(ЭтотОбъект, Истина, Истина);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ПрочитатьДанныеСотрудника();
	
	ПодключитьОбработчикОжидания("ПриИзмененииСохраняемойНастройки", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникАдресЭлектроннойПочтыНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УправлениеКонтактнойИнформациейКлиент.СоздатьЭлектронноеПисьмо("", ЭлектронныйАдрес, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.EMailФизическиеЛица"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НовыйСотрудник(Команда)
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСотрудникаВАрхив(Команда)
	
	ОтправитьСотрудникаВАрхивНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПриемНаРаботу(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ПриемНаРаботу");
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорРаботыУслуги(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ДоговорРаботыУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорАвторскогоЗаказа(Команда)
	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, Элементы.СотрудникиБезОтношений.ТекущаяСтрока, "Документы.ДоговорАвторскогоЗаказа");
КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправкаОЗаработке(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьКадровыхПриказовРасширенная", "ПФ_MXL_СправкаОДоходахПроизвольнаяФорма",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправкаСМестаРаботы(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьКадровыхПриказовРасширенная", "ПФ_MXL_СправкаСМестаРаботы",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправка2НДФЛ(Команда)
	
	Если НЕ СотрудникЗаполнен() Тогда
		Возврат;
	КонецЕсли; 
	
	ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ = Справки2НДФЛ(Сотрудник);
	
	СписокСправок = ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.Справки2НДФЛ;
	
	ДополнительныеПараметры = Новый Структура("ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ);
	
	Если СписокСправок.Количество() > 0 Тогда
		
		СписокСправок.Добавить(ПредопределенноеЗначение("Документ.СправкаНДФЛ.ПустаяСсылка"), НСтр("ru = 'Новая справка';
																									|en = 'New certificate'"));
		
		Оповещение = Новый ОписаниеОповещения("СотрудникСправка2НДФЛЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВыборИзСписка(Оповещение, СписокСправок, Элементы.СотрудникСправка2НДФЛ);

	Иначе
		СотрудникСправка2НДФЛЗавершение(Новый Структура("Значение", ПредопределенноеЗначение("Документ.СправкаНДФЛ.ПустаяСсылка")), ДополнительныеПараметры);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникСправка2НДФЛЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СсылкаНаСправку = ВыбранноеЗначение.Значение;
	ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ = ДополнительныеПараметры.ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ;
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ЗначениеЗаполнено(СсылкаНаСправку) Тогда
		ПараметрыОткрытия.Вставить("Ключ", СсылкаНаСправку);
	Иначе
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Сотрудник", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.ФизическоеЛицо);
		ЗначенияЗаполнения.Вставить("Организация", ОписаниеСотрудникаИИмеющихсяСправок2НДФЛ.Организация);
		
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.СправкаНДФЛ.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, Сотрудник, Команда.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудникиСОшибками

&НаСервереБезКонтекста
Процедура СотрудникиСОшибкамиПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для Каждого КлючИЗначение Из Строки Цикл
		
		ПредставленияОшибки = Новый Массив;
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение.Данные.ДатаРождения) Тогда
			ПредставленияОшибки.Добавить(НСтр("ru = 'дата рождения';
												|en = 'date of birth'"));
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение.Данные.ИНН) Тогда
			ПредставленияОшибки.Добавить(НСтр("ru = 'ИНН';
												|en = 'TIN'"));
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение.Данные.СтраховойНомерПФР) Тогда
			ПредставленияОшибки.Добавить(НСтр("ru = 'СНИЛС';
												|en = 'SNILS'"));
		КонецЕсли;
		
		Если Не КлючИЗначение.Значение.Данные.ЕстьЗаявление Тогда
			ПредставленияОшибки.Добавить(НСтр("ru = 'Заявление о способе ведения трудовой книжки';
												|en = 'Application on the employment record book maintaining method'"));
		КонецЕсли;
		
		Если ПредставленияОшибки.Количество() > 0 Тогда
			КлючИЗначение.Значение.Данные.ПредставлениеОшибки = СтрСоединить(ПредставленияОшибки, ", ");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКадровыеПриказыНеПроведенные

&НаКлиенте
Процедура КадровыеПриказыНеПроведенныеПриИзменении(Элемент)
	
	ОбновитьСписки(ЭтотОбъект, Истина, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПользователя", "Организация", Организация);
	УстановитьОтборЖурналовПоОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСохраняемойНастройки()
	
	Настройки = СохраняемыеНастройки();
	Настройки.Сотрудник = Сотрудник;
	
	СохранитьНастройкиНаСервере(Настройки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СохраняемыеНастройки()
	
	Настройки = Новый Структура("Сотрудник");
	Возврат Настройки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(Настройки)
	
	Для Каждого КлючИЗначение Из Настройки Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РаботаСКадрами", КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборЖурналовПоОрганизации()
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(КадровыеПриказыНеПроведенные.Отбор, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(КадровыеПриказыЗавершенные.Отбор, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(СотрудникиБезОтношений.Отбор, "ГоловнаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(СотрудникиСОшибками.Отбор, "ГоловнаяОрганизация");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыНеПроведенные.Отбор, "Организация", Организация);	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КадровыеПриказыЗавершенные.Отбор, "Организация", Организация);	
	
	ГоловнаяОрганизация = ГоловнаяОрганизация(Организация);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СотрудникиБезОтношений.Отбор, "ГоловнаяОрганизация", ГоловнаяОрганизация);	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СотрудникиСОшибками.Отбор, "ГоловнаяОрганизация", ГоловнаяОрганизация);	
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеСотрудника()
	
	ПредставлениеРабочегоМеста = "";
	СотрудникДатаРождения = "";
	СотрудникАдрес = "";
	СотрудникИНН = "";
	СотрудникСНИЛС = "";
	СотрудникТелефон = "";
	СотрудникДокумент = "";
	СотрудникАдресЭлектроннойПочты = "";
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(КадровыеПриказыСотрудника, "Сотрудник", Сотрудник);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(КадровыеПриказыСотрудника, "Сотрудник", Неопределено);
	КонецЕсли;
	
	ДатаУвольнения = Неопределено;
	ОформленПоТрудовомуДоговору = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.Адрес);
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	МассивТипов.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидыКонтактнойИнформации.Ссылка,
		|	ВидыКонтактнойИнформации.Тип,
		|	ВидыКонтактнойИнформации.РеквизитДопУпорядочивания
		|ПОМЕСТИТЬ ВТВидыКонтактнойИнформации
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Тип В(&МассивТипов)
		|	И ВидыКонтактнойИнформации.Родитель = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СправочникФизическиеЛица)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВТВидыКонтактнойИнформации.Ссылка
		|ИЗ
		|	ВТВидыКонтактнойИнформации КАК ВТВидыКонтактнойИнформации
		|ГДЕ
		|	ВТВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТВидыКонтактнойИнформации.Ссылка,
		|	ВТВидыКонтактнойИнформации.РеквизитДопУпорядочивания
		|ИЗ
		|	ВТВидыКонтактнойИнформации КАК ВТВидыКонтактнойИнформации
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТВидыКонтактнойИнформации.Ссылка.РеквизитДопУпорядочивания";
		
	Запрос.УстановитьПараметр("МассивТипов", МассивТипов);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивВидов = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить().ВыгрузитьКолонку("Ссылка");
	ВидимостьПоляЭлектронногоАдреса = НЕ РезультатЗапроса[РезультатЗапроса.Количество() - 2].Пустой();
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		НеобходимыеКадровыеДанные = "ФизическоеЛицо,ДатаРождения,ДатаУвольнения,ОформленПоТрудовомуДоговору,ИНН,СтраховойНомерПФР,ДокументПредставление,ДокументВид,"
			+ "ГоловнаяОрганизация,ТекущаяОрганизация,ТекущееПодразделение,ТекущаяДолжность,ТекущаяДолжностьПоШтатномуРасписанию";
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, НеобходимыеКадровыеДанные, ТекущаяДатаСеанса());
		Если КадровыеДанные.Количество() = 0 Тогда
			Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
		Иначе
			
			ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпциюФормы("ИспользоватьНесколькоОрганизаций");
			
			ДанныеСотрудника = КадровыеДанные[0];
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ТекущаяОрганизация) Тогда
				
				Если ДанныеСотрудника.ОформленПоТрудовомуДоговору Тогда
					
					Если ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание") Тогда
						ПредставлениеРабочегоМеста = Строка(ДанныеСотрудника.ТекущаяДолжностьПоШтатномуРасписанию);
					Иначе
						ПредставлениеРабочегоМеста = Строка(ДанныеСотрудника.ТекущаяДолжность)
							+ " /" + Строка(ДанныеСотрудника.ТекущееПодразделение) + "/";
					КонецЕсли; 
					
					Если ИспользоватьНесколькоОрганизаций Тогда
						ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " (" + ДанныеСотрудника.ТекущаяОрганизация + ")";
					КонецЕсли; 
				
				Иначе
					
					ПредставлениеРабочегоМеста = НСтр("ru = 'Договорник';
														|en = 'Contract worker '") + " ";
					Если ИспользоватьНесколькоОрганизаций Тогда
						ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " " + ДанныеСотрудника.ТекущаяОрганизация;
					КонецЕсли; 
					
				КонецЕсли;
				
			Иначе
				
				ПредставлениеРабочегоМеста = НСтр("ru = 'Не оформлен';
													|en = 'Not registered'");
				Если ИспользоватьНесколькоОрганизаций Тогда
					ПредставлениеРабочегоМеста = ПредставлениеРабочегоМеста + " " + НСтр("ru = 'в';
																						|en = 'in'") + " " +  ДанныеСотрудника.ГоловнаяОрганизация;
				КонецЕсли;
				
			КонецЕсли;
			
			ФизическоеЛицо = ДанныеСотрудника.ФизическоеЛицо;
			ДатаУвольнения = ДанныеСотрудника.ДатаУвольнения;
			ОформленПоТрудовомуДоговору = ДанныеСотрудника.ОформленПоТрудовомуДоговору;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ДатаРождения) Тогда
				СотрудникДатаРождения = Формат(ДанныеСотрудника.ДатаРождения, "ДЛФ=DD");
			Иначе
				СотрудникДатаРождения = "<" + НСтр("ru = 'дата рождения не заполнена';
													|en = 'date of birth is not filled in'") + ">";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.ИНН) Тогда
				СотрудникИНН = ДанныеСотрудника.ИНН;
			Иначе
				СотрудникИНН = "<" + НСтр("ru = 'ИНН не заполнен';
											|en = 'TIN is not filled in'") + ">";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеСотрудника.СтраховойНомерПФР) Тогда
				СотрудникСНИЛС = ДанныеСотрудника.СтраховойНомерПФР;
			Иначе
				СотрудникСНИЛС = "<" + НСтр("ru = 'СНИЛС не заполнен';
											|en = 'SNILS is not filled in'") + ">";
			КонецЕсли;

			Если НЕ ПустаяСтрока(ДанныеСотрудника.ДокументПредставление) Тогда
				
				СотрудникДокумент = ДанныеСотрудника.ДокументПредставление;
				
				СотрудникДокумент = СтрЗаменить(СотрудникДокумент, НСтр("ru = 'серия';
																		|en = 'series'"), "") + ":";
				СотрудникДокумент = СтрЗаменить(СотрудникДокумент, ", №", "");
				
				СотрудникДокумент = СокрЛП(СотрудникДокумент);
				
			Иначе
				СотрудникДокумент = "<" + НСтр("ru = 'документ, удостоверяющий личность не заполнен';
												|en = 'identity document is not filled in'") + ">";
			КонецЕсли;
			
			// Контактная информация
			ТаблицаКонтактнойИнформации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
				МассивТипов,
				МассивВидов);
			
			СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				
				ЭлектронныйАдрес = НайденныеСтроки[0].Представление;

				СотрудникАдресЭлектроннойПочты = ПредставлениеКонтактнойИнформации(
					НайденныеСтроки[0].Представление,
					НайденныеСтроки[0].Вид,
					Строка(НайденныеСтроки[0].Тип));
					
			Иначе
				ЭлектронныйАдрес = "";
				СотрудникАдресЭлектроннойПочты = "<" + НСтр("ru = 'адрес электронной почты не заполнен';
															|en = 'email address is not entered'") + ">";
			КонецЕсли;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"СотрудникАдресЭлектроннойПочты",
				"Гиперссылка",
				НЕ ПустаяСтрока(ЭлектронныйАдрес));
			
			СтруктураПоиска = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СотрудникТелефон = НайденныеСтроки[0].Представление;
			Иначе
				
				СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
				НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
				
					СотрудникТелефон = ПредставлениеКонтактнойИнформации(
						НайденныеСтроки[0].Представление,
						НайденныеСтроки[0].Вид,
						Строка(НайденныеСтроки[0].Тип));

				Иначе
					СотрудникТелефон = "<" + НСтр("ru = 'телефон не заполнен';
													|en = 'phone is not filled in'") + ">";
				КонецЕсли;
				
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.АдресМестаПроживанияФизическиеЛица);
			НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СотрудникАдрес = НайденныеСтроки[0].Представление;
			Иначе
				
				СтруктураПоиска = Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
				НайденныеСтроки = ТаблицаКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
				
					СотрудникАдрес = ПредставлениеКонтактнойИнформации(
						НайденныеСтроки[0].Представление,
						НайденныеСтроки[0].Вид,
						Строка(НайденныеСтроки[0].Тип));

				Иначе
					СотрудникАдрес = "<" + НСтр("ru = 'адрес не заполнен';
												|en = 'address is not filled in'") + ">";
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаВсеДанныеСотрудника",
			"Доступность",
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОформитьУвольнение",
			"Видимость",
			ОформленПоТрудовомуДоговору И НЕ ЗначениеЗаполнено(ДатаУвольнения));
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"СотрудникАдресЭлектроннойПочты",
			"Видимость",
			ВидимостьПоляЭлектронногоАдреса);
			
		ПараметрыПостроения = Новый Структура;
		ПараметрыПостроения.Вставить("Сотрудник", Сотрудник);
		ПараметрыПостроения.Вставить("ОформленПоТрудовомуДоговору", ОформленПоТрудовомуДоговору);
		ПараметрыПостроения.Вставить("ДатаУвольнения", ДатаУвольнения);
		
		СотрудникиФормы.УстановитьМенюВводаНаОсновании(ЭтотОбъект, "ОформитьДокумент", ПараметрыПостроения);
		
	Иначе
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаВсеДанныеСотрудника",
			"Доступность",
			Ложь);
			
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		ЭтотОбъект,
		"Сотрудник",
		ПредставлениеРабочегоМеста);
			
КонецПроцедуры

&НаСервере
Функция ПредставлениеКонтактнойИнформации(Представление, ВидПредставление, ТипПредставление)
	
	Если СтрНайти(ВидПредставление, ТипПредставление) = 1 Тогда
		ПредставлениеВида = СокрЛП(Сред(ВидПредставление, СтрДлина(ТипПредставление) + 1));
	Иначе
		ПредставлениеВида = ВидПредставление;
	КонецЕсли;
	
	Возврат Представление + " (" + ПредставлениеВида + ")";
		
КонецФункции

&НаСервере
Функция ГоловнаяОрганизация(Организация)
	УстановитьПривилегированныйРежим(Истина);
	Возврат РегламентированнаяОтчетность.ГоловнаяОрганизация(Организация);
КонецФункции

&НаСервере
Процедура ОтправитьСотрудникаВАрхивНаСервере()
	
	Если Элементы.СотрудникиБезОтношений.ТекущаяСтрока <> Неопределено Тогда
		КадровыйУчет.ПоместитьСотрудникаВАрхив(Элементы.СотрудникиБезОтношений.ТекущаяСтрока);
		ОбновитьСписки(ЭтотОбъект, Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписки(Форма, СпискиСотрудников, СпискиДокументов)
	
	Если  СпискиСотрудников Тогда
		Форма.Элементы.СотрудникиБезОтношений.Обновить();
		Форма.Элементы.СотрудникиСОшибками.Обновить();
	КонецЕсли;
	
	Если СпискиДокументов Тогда
		Форма.Элементы.КадровыеПриказыСотрудника.Обновить();
		Форма.Элементы.КадровыеПриказыЗавершенные.Обновить();
		Форма.Элементы.КадровыеПриказыНеПроведенные.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция Справки2НДФЛ(Знач Сотрудник)
	
	ВозвращаемаяСтруктура = Новый Структура("ФизическоеЛицо,Организация,Справки2НДФЛ", , , Новый СписокЗначений);
	
	Запрос = Новый Запрос;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, "ФизическоеЛицо,ТекущаяОрганизация");
	
	ВозвращаемаяСтруктура.ФизическоеЛицо = КадровыеДанные[0].ФизическоеЛицо;
	ВозвращаемаяСтруктура.Организация = КадровыеДанные[0].ТекущаяОрганизация;
	
	Запрос.УстановитьПараметр("Сотрудник", ВозвращаемаяСтруктура.ФизическоеЛицо);
	Запрос.УстановитьПараметр("Организация", ВозвращаемаяСтруктура.Организация);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправкаНДФЛ.Ссылка
		|ПОМЕСТИТЬ ВТВсеСправки
		|ИЗ
		|	Документ.СправкаНДФЛ КАК СправкаНДФЛ
		|ГДЕ
		|	СправкаНДФЛ.Сотрудник = &Сотрудник
		|	И СправкаНДФЛ.Организация = &Организация
		|	И НЕ СправкаНДФЛ.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеСправки.Ссылка.НалоговыйПериод КАК НалоговыйПериод
		|ПОМЕСТИТЬ ВТНалоговыеПериоды
		|ИЗ
		|	ВТВсеСправки КАК ВсеСправки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НалоговыеПериоды.НалоговыйПериод,
		|	МАКСИМУМ(ВсеСправки.Ссылка.Дата) КАК Дата
		|ПОМЕСТИТЬ ВТДатыПоследнихСправокВПериоде
		|ИЗ
		|	ВТНалоговыеПериоды КАК НалоговыеПериоды,
		|	ВТВсеСправки КАК ВсеСправки
		|
		|СГРУППИРОВАТЬ ПО
		|	НалоговыеПериоды.НалоговыйПериод
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДатыПоследнихСправокВПериоде.НалоговыйПериод КАК НалоговыйПериод,
		|	МАКСИМУМ(ВсеСправки.Ссылка) КАК Ссылка
		|ИЗ
		|	ВТДатыПоследнихСправокВПериоде КАК ДатыПоследнихСправокВПериоде
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВсеСправки КАК ВсеСправки
		|		ПО ДатыПоследнихСправокВПериоде.Дата = ВсеСправки.Ссылка.Дата
		|
		|СГРУППИРОВАТЬ ПО
		|	ДатыПоследнихСправокВПериоде.НалоговыйПериод
		|
		|УПОРЯДОЧИТЬ ПО
		|	НалоговыйПериод УБЫВ";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВозвращаемаяСтруктура.Справки2НДФЛ.Добавить(Выборка.Ссылка, Выборка.НалоговыйПериод);
	КонецЦикла;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

&НаКлиенте
Функция СотрудникЗаполнен()
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите сотрудника';
										|en = 'Select an employee'"));
		Возврат Ложь;
		
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура НачатьЗакрытиеФормы()
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Повторное открытие формы';
										|en = 'Reopen the form'");
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос = Ложь;
	
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить(КодВозвратаДиалога.ОК);
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(
		Новый ОписаниеОповещения("ЗавершитьЗакрытиеФормы", ЭтотОбъект), 
		НСтр("ru = '«Работа с кадрами» будет закрыта, повторите открытие еще раз';
			|en = '""Human resource management"" will be closed. Try to open again'"), 
		Кнопки, 
		ПараметрыВопроса);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗакрытиеФормы(Результат, ДополнительныеПараметры) Экспорт
	Закрыть();
КонецПроцедуры

#КонецОбласти