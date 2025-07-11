
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ФормаСохранитьНастройку.Доступность = Ложь;
	КонецЕсли;
	
	ОписаниеФункций = УправлениеДаннымиОбИзделияхПовтИсп.ОписаниеФункцийАвтовыбораЗначенияСвойстваНоменклатуры();
		
	// Добавим свойства продукции, которые можно сопоставить
	СвойстваМатериала = УправлениеДаннымиОбИзделиях.ПолучитьСвойстваДляАвтовыбора(Параметры.ВидМатериала, Истина);
	СвойстваПродукции = УправлениеДаннымиОбИзделиях.ПолучитьСвойстваДляАвтовыбора(Параметры.ВидИзделий);
	Для каждого ДанныеСвойстваМатериала Из СвойстваМатериала Цикл
		
		Если ДанныеСвойстваМатериала.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = СоответствиеСвойств.Добавить();
		НоваяСтрока.СвойствоМатериала = ДанныеСвойстваМатериала.Свойство;
		НоваяСтрока.СвойствоМатериалаПредставление = ДанныеСвойстваМатериала.Представление;
		
		// Свойства можно сопоставить, если
		// - свойства одинаковые
		// - свойства разные, но используется общий список значений
		// - тип свойства примитивный (число, строка, булево, дата).
		Для каждого ДанныеСвойстваПродукции Из СвойстваПродукции Цикл
			
			Если ДанныеСвойстваПродукции.ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
			
			Если (ДанныеСвойстваПродукции.Свойство = ДанныеСвойстваМатериала.Свойство
				
					ИЛИ ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений = ДанныеСвойстваМатериала.Свойство
					
					ИЛИ ДанныеСвойстваПродукции.Свойство = ДанныеСвойстваМатериала.ВладелецДополнительныхЗначений
					
					ИЛИ ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений = ДанныеСвойстваМатериала.ВладелецДополнительныхЗначений
						И ЗначениеЗаполнено(ДанныеСвойстваПродукции.ВладелецДополнительныхЗначений)
						
					ИЛИ ДанныеСвойстваМатериала.ТипЗначения = ДанныеСвойстваПродукции.ТипЗначения
						И НЕ ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"))
						
				) Тогда
				
				НоваяСтрока.СписокДоступныхСвойств.Добавить(ДанныеСвойстваПродукции.Свойство, ДанныеСвойстваПродукции.Представление);
				
			КонецЕсли;
			
		КонецЦикла;
		
		НоваяСтрока.ЕстьДоступныеСвойстваДляВыбора = (НоваяСтрока.СписокДоступныхСвойств.Количество() <> 0);
		
		НоваяСтрока.ЕстьВозможностьРасчетаПоФормуле = ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Число"))
			ИЛИ ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Строка"))
			ИЛИ ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип("Булево"));
			
		// Добавление функций подбора значения по алгоритму
		Если ОписаниеФункций.Количество() Тогда
			Для каждого Описание Из ОписаниеФункций Цикл
				
				Если НЕ ТипЗнч(Описание) = Тип("Структура") ИЛИ НЕ Описание.Свойство("ИмяФункции") Тогда
					Продолжить;
				КонецЕсли;
				
				ИмяСвойства = "";
				Если Описание.Параметры.Свойство("ИмяСвойства", ИмяСвойства) И ИмяСвойства <> ДанныеСвойстваМатериала.Имя Тогда
					Продолжить;
				КонецЕсли;
				
				Если Описание.ВозвращаемоеЗначение <> Неопределено Тогда
					Для каждого Тип Из Описание.ВозвращаемоеЗначение.Типы() Цикл
						ДобавитьФункцию = ДанныеСвойстваМатериала.Свойство.ТипЗначения.СодержитТип(Тип);
						Если ДобавитьФункцию Тогда
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если НЕ ДобавитьФункцию Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				
				НоваяСтрока.СписокДоступныхФункций.Добавить(Описание.ИмяФункции, Описание.Представление);
				
			КонецЦикла;
			НоваяСтрока.СписокДоступныхФункций.СортироватьПоПредставлению();
			НоваяСтрока.ЕстьДоступныеФункцииДляВыбора = (НоваяСтрока.СписокДоступныхФункций.Количество() <> 0);
		КонецЕсли;
			
	КонецЦикла;
	
	// Заполним соответствие свойств
	Для каждого ТекущиеДанные Из СоответствиеСвойств Цикл
		
		СтруктураПоиска = Новый Структура("СвойствоМатериала", ТекущиеДанные.СвойствоМатериала);
		СписокСтрок = Параметры.СоответствиеСвойств.НайтиСтроки(СтруктураПоиска);
		
		ТекущиеДанные.СпособПодбораЗначения = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ЛюбоеЗначение;
		
		Если СписокСтрок.Количество() <> 0 Тогда
			
			НастройкаСоответствия = СписокСтрок[0];
			
			ТекущиеДанные.СпособПодбораЗначения = НастройкаСоответствия.СпособПодбораЗначения;
			
			Если ТекущиеДанные.СпособПодбораЗначения = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству Тогда
				
				ЭлСвойствоПродукции = ТекущиеДанные.СписокДоступныхСвойств.НайтиПоЗначению(НастройкаСоответствия.СвойствоПродукции);
				Если ЭлСвойствоПродукции <> Неопределено Тогда
					
					ТекущиеДанные.СвойствоПродукции              = НастройкаСоответствия.СвойствоПродукции;
					ТекущиеДанные.СвойствоПродукцииПредставление = ЭлСвойствоПродукции.Представление;
					
				КонецЕсли;
				
			ИначеЕсли ТекущиеДанные.СпособПодбораЗначения = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоЗначению Тогда
				
				ТекущиеДанные.ЗначениеСвойства = НастройкаСоответствия.ЗначениеСвойства;
				
			ИначеЕсли ТекущиеДанные.СпособПодбораЗначения = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоФормуле Тогда
				
				ТекущиеДанные.АлгоритмРасчетаЗначения = НастройкаСоответствия.АлгоритмРасчетаЗначения;
				
			ИначеЕсли ТекущиеДанные.СпособПодбораЗначения = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоАлгоритму Тогда
				
				ЭлСпискаФункций = ТекущиеДанные.СписокДоступныхФункций.НайтиПоЗначению(НастройкаСоответствия.АлгоритмРасчетаЗначения);
				Если ЭлСпискаФункций <> Неопределено Тогда
					
					ТекущиеДанные.АлгоритмРасчетаЗначения              = НастройкаСоответствия.АлгоритмРасчетаЗначения;
					ТекущиеДанные.АлгоритмРасчетаЗначенияПредставление = ЭлСпискаФункций.Представление;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СформироватьДанныеДляПодбораПоФормуле(СвойстваПродукции);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
							|en = 'Data has changed. Save the changes?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоответствиеСвойств

&НаКлиенте
Процедура СоответствиеСвойствСпособОпределенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	ОчиститьСоответствиеВСтроке(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСвойствСвойствоПродукцииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	
	Если ТекущиеДанные.ЕстьДоступныеСвойстваДляВыбора Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СвойствоПродукцииНачалоВыбораЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, ТекущиеДанные.СписокДоступныхСвойств, Элемент);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСвойствЗначениеИлиСвойствоПродукцииОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	ОчиститьСоответствиеВСтроке(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСвойствСпособОпределенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	
	СписокВыбора = Элементы.СоответствиеСвойствСпособПодбораЗначения.СписокВыбора;
	СписокВыбора.Очистить();
	
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству"), НСтр("ru = 'по свойству';
																																|en = 'by property'"));
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоЗначению"), НСтр("ru = 'по значению';
																																|en = 'by value'"));
	
	Если ТекущиеДанные.ЕстьВозможностьРасчетаПоФормуле Тогда
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоФормуле"), НСтр("ru = 'по формуле';
																																	|en = 'by formula'"));
	КонецЕсли;
	
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоАлгоритму"), НСтр("ru = 'по алгоритму';
																																|en = 'by algorithm'"));
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ЛюбоеЗначение"), НСтр("ru = 'любое значение';
																																	|en = 'any value'"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеСвойствАлгоритмРасчетаЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	
	ПараметрыФормы = ПараметрыФормыРедактированияФормулы(ТекущиеДанные.АлгоритмРасчетаЗначения);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("АлгоритмРасчетаЗначенияНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПараметрыФормы, 
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура СоответствиеСвойствФункцияРасчетаЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
	
	Если ТекущиеДанные.ЕстьДоступныеФункцииДляВыбора Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ФункцияРасчетаЗначенияНачалоВыбораЗавершение", ЭтотОбъект);
		ПоказатьВыборИзСписка(ОписаниеОповещения, ТекущиеДанные.СписокДоступныхФункций, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСоответствие(Команда)
	
	Для каждого ТекущиеДанные Из СоответствиеСвойств Цикл
		
		Если ТекущиеДанные.СписокДоступныхСвойств.Количество() = 1
			И ТекущиеДанные.СпособПодбораЗначения = ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ЛюбоеЗначение") Тогда
			
			ТекущиеДанные.СпособПодбораЗначения          = ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству");
			ТекущиеДанные.СвойствоПродукции              = ТекущиеДанные.СписокДоступныхСвойств[0].Значение;
			ТекущиеДанные.СвойствоПродукцииПредставление = ТекущиеДанные.СписокДоступныхСвойств[0].Представление;
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДанныеДляКонструктораФормул

&НаСервере
Функция ПараметрыФормыРедактированияФормулы(Формула)
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Формула", Формула);
	ПараметрыФормы.Вставить("ДеревоОперандов", АдресХранилищаДереваОперандов);
	ПараметрыФормы.Вставить("Операторы", АдресХранилищаДереваОператоров);
	ПараметрыФормы.Вставить("ИспользуетсяДеревоОперандов", Истина);
	ПараметрыФормы.Вставить("ФункцииИзОбщегоМодуля", УправлениеДаннымиОбИзделияхПовтИсп.ОписаниеФункцийКонструктораФормул());
	ПараметрыФормы.Вставить("ТипРезультата", Новый ОписаниеТипов("Число"));
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура СформироватьДанныеДляПодбораПоФормуле(СвойстваПродукции)
	
	ДеревоОперандов = РаботаСФормулами.ПолучитьПустоеДеревоОперандов();
	ТипыЭлементовДерева = РаботаСФормулами.ТипыЭлементовДереваОперандов();
	
	ГруппаПродукция = РаботаСФормулами.НоваяСтрокаДереваОперанда(ДеревоОперандов);
	ГруппаПродукция.Идентификатор = "СвойстваПродукции";
	ГруппаПродукция.Представление = НСтр("ru = 'Свойства продукции';
										|en = 'Product properties'");
	ГруппаПродукция.ТипЭлементаДерева = ТипыЭлементовДерева.ГруппаСтрокВерхнегоУровня;
	ГруппаПродукция.РазрешаетсяВыборОперанда = Ложь;
	ГруппаПродукция.ВключаетсяВИдентификатор = Ложь;
	
	Для каждого Свойство Из СвойстваПродукции Цикл
		Если Свойство.ТипЗначения.СодержитТип(Тип("Число")) 
			ИЛИ Свойство.ТипЗначения.СодержитТип(Тип("Строка")) 
			ИЛИ Свойство.ТипЗначения.СодержитТип(Тип("Булево")) Тогда
			СтрокаОперанда = РаботаСФормулами.НоваяСтрокаДереваОперанда(ГруппаПродукция);
			СтрокаОперанда.Идентификатор = Свойство.Идентификатор;
			СтрокаОперанда.Представление = Свойство.Представление;
			СтрокаОперанда.ТипЗначения = Свойство.ТипЗначения;
			СтрокаОперанда.ТипЭлементаДерева = ТипыЭлементовДерева.ДополнительныйРеквизит;
		КонецЕсли;
	КонецЦикла;
	
	АдресХранилищаДереваОперандов = ПоместитьВоВременноеХранилище(ДеревоОперандов, УникальныйИдентификатор);
	
	ДеревоОператоров = УправлениеДаннымиОбИзделиях.ПостроитьДеревоОператоров();
	АдресХранилищаДереваОператоров = ПоместитьВоВременноеХранилище(ДеревоОператоров, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Видимость поля <СвойствоПродукции>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствСвойствоПродукции.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	
	СписокСпособовОпределения = Новый СписокЗначений;
	СписокСпособовОпределения.Добавить(Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству);
	СписокСпособовОпределения.Добавить(Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ЛюбоеЗначение);
	
	ОтборЭлемента.ПравоеЗначение = СписокСпособовОпределения;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Видимость поля <ЗначениеСвойства>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствЗначениеСвойства.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоЗначению;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Видимость поля <АлгоритмРасчетаЗначения (по формуле)>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствАлгоритмРасчетаЗначения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоФормуле;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Видимость поля <АлгоритмРасчетаЗначения (по алгоритму)>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствФункцияРасчетаЗначения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоАлгоритму;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Доступность поля <СвойствоПродукции>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствСвойствоПродукции.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ЛюбоеЗначение;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	// Оформление пустого списка выбора поля <СвойствоПродукции>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствСвойствоПродукции.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.ЕстьДоступныеСвойстваДляВыбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<нет свойств доступных для выбора>';
																|en = '<no properties to select>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	// Оформление пустого списка выбора поля <ФункцияРасчетаЗначения>
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствФункцияРасчетаЗначения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.ЕстьДоступныеФункцииДляВыбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоАлгоритму;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<нет алгоритмов доступных для выбора>';
																|en = '<no algorithm to select>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	// Оформление поля <Способ определения>
	Для каждого СпособПодбораЗначения Из Перечисления.СпособыПодбораЗначенияСвойстваНоменклатуры Цикл
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СоответствиеСвойствСпособПодбораЗначения.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СоответствиеСвойств.СпособПодбораЗначения");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = СпособПодбораЗначения;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НРег(СпособПодбораЗначения));
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСоответствиеВСтроке(ТекущиеДанные)
	
	ТекущиеДанные.СвойствоПродукции = Неопределено;
	ТекущиеДанные.СвойствоПродукцииПредставление = Неопределено;
	ТекущиеДанные.ЗначениеСвойства = Неопределено;
	ТекущиеДанные.АлгоритмРасчетаЗначения = "";

КонецПроцедуры

&НаКлиенте
Процедура СвойствоПродукцииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
		
		ТекущиеДанные.СвойствоПродукции              = ВыбранныйЭлемент.Значение;
		ТекущиеДанные.СвойствоПродукцииПредставление = ВыбранныйЭлемент.Представление;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмРасчетаЗначенияНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
		
		ТекущиеДанные.АлгоритмРасчетаЗначения = СокрЛП(РезультатЗакрытия);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФункцияРасчетаЗначенияНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия <> Неопределено Тогда
		
		ТекущиеДанные = Элементы.СоответствиеСвойств.ТекущиеДанные;
		
		ТекущиеДанные.АлгоритмРасчетаЗначения              = РезультатЗакрытия.Значение;
		ТекущиеДанные.АлгоритмРасчетаЗначенияПредставление = РезультатЗакрытия.Представление;
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	Отказ = Ложь;
	
	ПоляПроверкиЗаполнения = Новый Соответствие;
	ПоляПроверкиЗаполнения.Вставить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоСвойству"),
		"СвойствоПродукцииПредставление");
	ПоляПроверкиЗаполнения.Вставить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоФормуле"),
		"АлгоритмРасчетаЗначения");
	ПоляПроверкиЗаполнения.Вставить(ПредопределенноеЗначение("Перечисление.СпособыПодбораЗначенияСвойстваНоменклатуры.ПоАлгоритму"),
		"АлгоритмРасчетаЗначенияПредставление");
	
	ШаблонСообщения = НСтр("ru = 'Необходимо заполнить значение настройки соответствия в строке %1';
							|en = 'Fill in setting value in line %1'");
	
	Результат = Новый Массив;
	Для каждого СтрокаСоответствие Из СоответствиеСвойств Цикл
		
		ПроверяемоеПоле = ПоляПроверкиЗаполнения[СтрокаСоответствие.СпособПодбораЗначения];
		Если ПроверяемоеПоле <> Неопределено И НЕ ЗначениеЗаполнено(СтрокаСоответствие[ПроверяемоеПоле]) Тогда
			ИндексСтроки = СоответствиеСвойств.Индекс(СтрокаСоответствие);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ШаблонСообщения, ИндексСтроки+1),,
				"СоответствиеСвойств["+ИндексСтроки+"]."+ПроверяемоеПоле,,Отказ);
		КонецЕсли;
		
		НастройкаСоответствия = Новый Структура(УправлениеДаннымиОбИзделияхКлиентСервер.РеквизитыНастройкаСоответствияСвойств());
		ЗаполнитьЗначенияСвойств(НастройкаСоответствия, СтрокаСоответствие);
		Результат.Добавить(НастройкаСоответствия);
		
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
