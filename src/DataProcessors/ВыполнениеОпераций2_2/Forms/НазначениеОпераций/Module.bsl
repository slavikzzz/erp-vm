
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаполнитьРеквизитыФормыПоПараметрам() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	
	НастроитьЭлементыФормы();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ИспользоватьУчастки Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Участок");
	КонецЕсли;
	
	Если МножественныйРежим Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Этап");
		МассивНепроверяемыхРеквизитов.Добавить("Операция");
		МассивНепроверяемыхРеквизитов.Добавить("Количество");
	КонецЕсли;
	
	ПараметрыПодразделения = ПроизводствоСерверПовтИсп.ПараметрыПроизводственногоПодразделения(Подразделение);
	Если Не ПараметрыПодразделения.ИспользоватьСменныеЗадания Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СменноеЗадание");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ВремяВыполнения = ОперативныйУчетПроизводстваКлиентСервер.РассчитатьВремяОперацииОтКоличества(
		Количество,
		КоличествоШтучное,
		ВремяШтучное,
		ВремяПЗ,
		ПараллельнаяЗагрузка,
		КоэффициентВремениРаботы);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Количество,ВремяВыполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяВыполненияПриИзменении(Элемент)
	
	Количество = ОперативныйУчетПроизводстваКлиентСервер.РассчитатьКоличествоОперацииОтВремени(
		ВремяВыполнения,
		ВремяШтучное,
		ВремяПЗ,
		КоличествоШтучное,
		КоэффициентВремениРаботы);
		
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Количество,ВремяВыполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПроизводствоКлиент.ОткрытьФормуВыбораИсполнителя(
		Организация,
		Подразделение,
		Исполнитель,
		Неопределено,
		,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		Исполнитель = Результат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СменноеЗаданиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Статусы = Новый СписокЗначений;
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСменныхЗаданий.Формируется"));
	Статусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыСменныхЗаданий.Сформировано"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение",       Подразделение);
	ПараметрыФормы.Вставить("Участок",             Участок);
	ПараметрыФормы.Вставить("Статусы",             Статусы);
	
	ОткрытьФорму(
		"Документ.СменноеЗадание.Форма.ФормаВыбораПоКалендарю",
		ПараметрыФормы,
		ЭтотОбъект,
		УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("СменноеЗаданиеНачалоВыбораЗавершение",ЭтаФорма),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Организация, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Организация, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	
	КоэффициентВремениРаботы = КоэффициентВремениРаботы(РабочийЦентр);
	ВремяВыполнения = ОперативныйУчетПроизводстваКлиентСервер.РассчитатьВремяОперацииОтКоличества(
		Количество,
		КоличествоШтучное,
		ВремяШтучное,
		ВремяПЗ,
		ПараллельнаяЗагрузка,
		КоэффициентВремениРаботы);
		
	РасчитатьЗагрузку();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	РасчитатьЗагрузку();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ОперативныйУчетПроизводстваКлиентСервер.ПараметрыНазначенияПроизводственнойОперацииКонструктор();
	
	Если МножественныйРежим Тогда
		ЗаполнитьЗначенияСвойств(Результат, ЭтаФорма, "Участок,СменноеЗадание,ВидРабочегоЦентра,РабочийЦентр,ВариантНаладки,Исполнитель");
	Иначе
		ЗаполнитьЗначенияСвойств(Результат, ЭтаФорма, "Участок,СменноеЗадание,ВидРабочегоЦентра,РабочийЦентр,ВариантНаладки,Исполнитель,Количество");
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Организация, Подразделение)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПараметрыОтбора = Новый Структура("Организация, Подразделение, Дата", Организация, Подразделение, ТекущаяДатаСеанса());
	
	ПроизводствоСервер.ЗаполнитьДанныеВыбораПриВводеИсполнителя(ДанныеВыбора, Текст, ПараметрыОтбора);
	
КонецПроцедуры

// Заполнение списка реквизитов по параметрам формы.
//
&НаСервере
Функция ЗаполнитьРеквизитыФормыПоПараметрам()
	
	Если Не ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.КлючиОпераций) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Параметры.Свойство("РежимРаботы", РежимРаботы) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Подразделение       = Параметры.Подразделение;
	ИспользоватьУчастки = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводственныеУчастки", Новый Структура("Подразделение", Подразделение));
	
	Если Параметры.Свойство("Исполнитель") Тогда
		Исполнитель = Параметры.Исполнитель;
	КонецЕсли;
	
	Если Параметры.Свойство("РабочийЦентр") Тогда
		РабочийЦентр = Параметры.РабочийЦентр;
	КонецЕсли;
	
	Если Параметры.Свойство("ВариантНаладки") Тогда
		ВариантНаладки = Параметры.ВариантНаладки;
	КонецЕсли;
	
	РасчитатьЗагрузку();
	
	Если Параметры.Свойство("Участок") Тогда
		Участок = Параметры.Участок;
	КонецЕсли;
	
	МножественныйРежим = Параметры.КлючиОпераций.Количество() > 1;
	
	Если Не МножественныйРежим Тогда
		
		ДанныеОперации = ОперативныйУчетПроизводстваВызовСервера.ДанныеОперацииИзОчереди(Параметры.КлючиОпераций[0]);
		
		Если ДанныеОперации <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(
				ЭтаФорма,
				ДанныеОперации,
				"Организация,Этап,Операция,ВидРабочегоЦентра,ЕдиницаИзмерения,ВремяШтучное,ВремяПЗ,ВремяЕдИзм,КоличествоШтучное,ПараллельнаяЗагрузка,КоэффициентВремениРаботы");
		КонецЕсли;
		
		Если РабочийЦентр.Пустая() Тогда
			РабочийЦентр = ДанныеОперации.РабочийЦентр;
		КонецЕсли;
		
		Если Участок.Пустая() Тогда
			Участок = ДанныеОперации.Участок;
		КонецЕсли;
		Если ВариантНаладки.Пустая() Тогда
			ВариантНаладки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеОперации.Операция, "ВариантНаладки");
		КонецЕсли;
		
		КоличествоЗапланировано = ДанныеОперации.Запланировано;
		
		Если РежимРаботы = РежимРаботыНазначить() Тогда
			КоличествоДоступно = ДанныеОперации.ОжиданиеСоздания;
		Иначе
			КоличествоДоступно = ДанныеОперации.МожноВыполнять;
		КонецЕсли;
		
		Если КоличествоДоступно <> 0 Тогда
			Количество = КоличествоДоступно;
		КонецЕсли;
		
		ВремяВыполнения = ОперативныйУчетПроизводстваКлиентСервер.РассчитатьВремяОперацииОтКоличества(
			Количество,
			КоличествоШтучное,
			ВремяШтучное,
			ВремяПЗ,
			ПараллельнаяЗагрузка,
			КоэффициентВремениРаботы);
			
		РеквизитыМаршрута = Справочники.ТехнологическиеОперации.РеквизитыМаршрутаОперации(ДанныеОперации.ОперацияВладелец);
		Маршрут = РеквизитыМаршрута.Маршрут;
		Элементы.Маршрут.Гиперссылка = РеквизитыМаршрута.МаршрутДоступен;
		
	Иначе
		
		ОбщееЗначение_ВидРабочегоЦентра = Неопределено;
		ОбщееЗначение_Организация = Неопределено;
		
		ДанныеОпераций = ОперативныйУчетПроизводстваВызовСервера.ДанныеОперацийИзОчереди(Параметры.КлючиОпераций);
		
		Для каждого ДанныеОперации Из ДанныеОпераций Цикл
			
			Если ОбщееЗначение_ВидРабочегоЦентра = Неопределено Тогда
				ОбщееЗначение_ВидРабочегоЦентра = ДанныеОперации.ВидРабочегоЦентра;
			ИначеЕсли ОбщееЗначение_ВидРабочегоЦентра <> ДанныеОперации.ВидРабочегоЦентра
				И ОбщееЗначение_ВидРабочегоЦентра <> Справочники.ВидыРабочихЦентров.ПустаяСсылка() Тогда
				ОбщееЗначение_ВидРабочегоЦентра = Справочники.ВидыРабочихЦентров.ПустаяСсылка();
				НесколькоВидовРабочихЦентров = Истина
			КонецЕсли;
			
			Если ОбщееЗначение_Организация = Неопределено Тогда
				ОбщееЗначение_Организация = ДанныеОперации.Организация;
			ИначеЕсли ОбщееЗначение_Организация <> ДанныеОперации.Организация
				И ОбщееЗначение_Организация <> Справочники.Организации.ПустаяСсылка() Тогда
				ОбщееЗначение_Организация = Справочники.Организации.ПустаяСсылка()
			КонецЕсли;
			
		КонецЦикла;
		
		ВидРабочегоЦентра = ОбщееЗначение_ВидРабочегоЦентра;
		Организация = ОбщееЗначение_Организация;
		
	КонецЕсли;
	
	Если ИспользоватьУчастки И НЕ РабочийЦентр.Пустая() Тогда
		
		УчастокРЦ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр, "Участок");
		
		Если Участок.Пустая()  Тогда
			Участок = УчастокРЦ;
		ИначеЕсли Участок <> УчастокРЦ Тогда
			РабочийЦентр = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура НастроитьЭлементыФормы() 
	
	// Связи параметров выбора рабочего центра
	#Область РабочийЦентр 
	
	Если НесколькоВидовРабочихЦентров Тогда
		Элементы.РабочийЦентр.Доступность = Ложь;
		Элементы.ВариантНаладки.Видимость = Ложь;
	Иначе
		
		МассивПараметров = Новый Массив;
		
		Если ВидРабочегоЦентра.Пустая() Тогда
			МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Подразделение", "Подразделение"));
		Иначе
			МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.ВидРабочегоЦентра", "ВидРабочегоЦентра"));
		КонецЕсли;
		Если ИспользоватьУчастки Тогда
			МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Участок", "Участок"));
		КонецЕсли;
		
		Элементы.РабочийЦентр.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	КонецЕсли;
	
	#КонецОбласти
	
	УстановитьТипИсполнителя();
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
	УстановитьЗаголовкиЭлементовФормы();
	
	Элементы.Участок.Видимость = ИспользоватьУчастки;
	
	Элементы.ВремяКоличество.Видимость            = Не МножественныйРежим;
	Элементы.ГруппаИнформацияПоЗагрузке.Видимость = Не МножественныйРежим;
	Элементы.ГруппаИнформацияПоОперации.Видимость = Не МножественныйРежим;
	
	Элементы.ВремяВыполнения.ТолькоПросмотр = ПараллельнаяЗагрузка;
	
	ПараметрыПодразделения = ПроизводствоСерверПовтИсп.ПараметрыПроизводственногоПодразделения(Подразделение);
	Элементы.СменноеЗадание.Видимость = ПараметрыПодразделения.ИспользоватьСменныеЗадания;
	
	Элементы.ВариантНаладки.Видимость = НЕ ВидРабочегоЦентра.Пустая()
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРабочегоЦентра, "ИспользуютсяВариантыНаладки");
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		//Замена текста кнопки на картинку
		Элементы.ФормаЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
		Элементы.ФормаЗаписатьИЗакрыть.Картинка = БиблиотекаКартинок.ЗаписатьИЗакрыть;
		
		//Перемещение операции и маршрутной карты
		Элементы.Переместить(Элементы.ГруппаДанныеОперации, ЭтаФорма, Элементы.ГруппаДобавитьОперацию);
		
		//Настройка РЦ и исполнителя
		Элементы.РабочийЦентр.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элементы.Исполнитель.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		
		Элементы.РабочийЦентр.ПодсказкаВвода = Нстр("ru = '<Рабочий центр>';
													|en = '<Work center>'");
		Элементы.Исполнитель.ПодсказкаВвода = Нстр("ru = '<Исполнитель>';
													|en = '<Assignee>'");
		
		//Настройка ширины полей
		Элементы.ЕдиницаИзмеренияПредставление.МаксимальнаяШирина              = 4;
		Элементы.ВремяЕдИзм.МаксимальнаяШирина                                 = 4;
		Элементы.ЕдиницаИзмеренияЗапланированоПредставление.МаксимальнаяШирина = 4;
		Элементы.ЕдиницаИзмеренияДоступноПредставление.МаксимальнаяШирина      = 4;
		
		Элементы.ГруппаЗапланировано.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		Элементы.ГруппаДоступно.Группировка      = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		
		Элементы.КоличествоЗапланировано.АвтоМаксимальнаяШирина   = Истина;
		Элементы.КоличествоЗапланировано.РастягиватьПоГоризонтали = Истина;
		Элементы.КоличествоЗапланировано.Вид                      = ВидПоляФормы.ПолеВвода;
		
		Элементы.КоличествоДоступно.АвтоМаксимальнаяШирина   = Истина;
		Элементы.КоличествоДоступно.РастягиватьПоГоризонтали = Истина;
		Элементы.КоличествоДоступно.Вид                      = ВидПоляФормы.ПолеВвода;
		
		Элементы.ЗагрузкаРЦ.РастягиватьПоГоризонтали          = Истина;
		Элементы.ЗагрузкаИсполнителя.РастягиватьПоГоризонтали = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиЭлементовФормы()
	
	// Установка заголовка формы
	#Область ЗаголовокФормы
	
	Если МножественныйРежим Тогда
		Если РежимРаботы = РежимРаботыНазначить() Тогда
			ТекстЗаголовок = НСтр("ru = 'Назначить выбранные операции';
									|en = 'Assign the selected operations'");
		ИначеЕсли РежимРаботы = РежимРаботыПринятьВРаботу() Тогда
			ТекстЗаголовок = НСтр("ru = 'Принять в работу выбранные операции';
									|en = 'Accept selected operations for processing'");
		ИначеЕсли РежимРаботы = РежимРаботыОтметитьВыполнение() Тогда
			ТекстЗаголовок = НСтр("ru = 'Отметить выполнение выбранных операций';
									|en = 'Mark the selected operations as performed'");
		КонецЕсли;
	Иначе
		Если РежимРаботы = РежимРаботыНазначить() Тогда
			ТекстЗаголовок = НСтр("ru = 'Назначить операцию';
									|en = 'Assign operation'");
		ИначеЕсли РежимРаботы = РежимРаботыПринятьВРаботу() Тогда
			ТекстЗаголовок = НСтр("ru = 'Принять в работу операцию';
									|en = 'Starting operation'");
		ИначеЕсли РежимРаботы = РежимРаботыОтметитьВыполнение() Тогда
			ТекстЗаголовок = НСтр("ru = 'Отметить выполнение операции';
									|en = 'Mark operation execution'");
		КонецЕсли;
		Если НЕ ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
			РеквизитыЭтапа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Этап, "Номер,НаименованиеЭтапа"); 
			ПредставлениеЭтапа = Документы.ЭтапПроизводства2_2.ПредставлениеЭтапа(РеквизитыЭтапа);
			ТекстЗаголовок = ТекстЗаголовок + " (" + ПредставлениеЭтапа + ", " + Операция + ")";
		КонецЕсли;
	КонецЕсли;
	
	АвтоЗаголовок = Ложь;
	Заголовок = ТекстЗаголовок;
	
	#КонецОбласти
	
	// Установка заголовка поля "Количество доступно"
	#Область КоличествоДоступно
	
	Если РежимРаботы = РежимРаботыНазначить() Тогда
		Элементы.КоличествоДоступно.Заголовок = НСтр("ru = 'Ожидает назначения';
													|en = 'Waiting for assignment '");
	Иначе
		Элементы.КоличествоДоступно.Заголовок = НСтр("ru = 'Можно выполнять';
													|en = 'Can be completed'");
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипИсполнителя()
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		
		ПараметрыПодразделения = ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
		
		УправлениеПроизводствомКлиентСервер.УстановитьТипИсполнителя(Исполнитель,
			ПараметрыПодразделения.ИспользоватьБригадныеНаряды,
			ПроизводствоСервер.ИспользуетсяУчетТрудозатратВРазрезеСотрудников(ТекущаяДатаСеанса()));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")

	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	// Настройка элемента Количество
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоДоступно") Тогда
		
		Если Форма.РежимРаботы <> РежимРаботыОтметитьВыполнение() Тогда
			Форма.Элементы.Количество.МаксимальноеЗначение = Форма.КоличествоДоступно;
		Иначе
			Форма.Элементы.Количество.МаксимальноеЗначение = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("Количество") Тогда
		
		Форма.ЕдиницаИзмеренияПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Форма.ЕдиницаИзмерения,
			Форма.Количество,
			Форма.ЭтоМобильныйКлиент);
		
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияЗапланированоПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоЗапланировано") Тогда
		
		Форма.ЕдиницаИзмеренияЗапланированоПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
			Форма.ЕдиницаИзмерения,
			Форма.КоличествоЗапланировано,
			Форма.ЭтоМобильныйКлиент);
		
	КонецЕсли;
	
	// Настройка элемента ЕдиницаИзмеренияДоступноПредставление
	Если Инициализация
		Или СтруктураРеквизитов.Свойство("КоличествоДоступно") Тогда
		
		Форма.ЕдиницаИзмеренияДоступноПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
				Форма.ЕдиницаИзмерения,
				Форма.КоличествоДоступно,
				Форма.ЭтоМобильныйКлиент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыНазначить()
	
	Возврат "Назначить";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыПринятьВРаботу()
	
	Возврат "ПринятьВРаботу";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция РежимРаботыОтметитьВыполнение()
	
	Возврат "ОтметитьВыполнение";
	
КонецФункции

&НаСервере
Процедура РасчитатьЗагрузку()
	
	Загрузка = ОперативныйУчетПроизводства.РассчитатьЗагрузку(РабочийЦентр, Исполнитель, Подразделение);
	
	ЗагрузкаРЦ          = Загрузка.РабочийЦентр;
	ЗагрузкаИсполнителя = Загрузка.Исполнитель;
	
КонецПроцедуры

&НаКлиенте
Процедура СменноеЗаданиеНачалоВыбораЗавершение(Результат, ДополнительныеПраметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		СменноеЗадание = Результат.Задания[0];
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоэффициентВремениРаботы(РабочийЦентр)
	
	Если Не РабочийЦентр.Пустая() Тогда
		КоэффициентВремениРаботы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр, "КоэффициентВремениРаботы");
	Иначе
		КоэффициентВремениРаботы = 1;
	КонецЕсли;
	
	Возврат КоэффициентВремениРаботы;
	
КонецФункции

#КонецОбласти