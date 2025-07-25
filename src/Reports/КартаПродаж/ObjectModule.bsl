#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеПользовательскихНастроекНаСервере.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ДопСвойства = ЭтаФорма.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	
	Экран = ПолучитьИнформациюЭкрановКлиента();
	DPI = ?(Экран.Количество(), Экран[0].DPI, 72);
	Ширина = Экран[0].Ширина / ?(DPI = 0, 72, DPI) * 25.4; // Ширина экрана в мм
	Высота = Ширина * 3 / 5;
	РазмерыРисунка = Новый Структура;
	РазмерыРисунка.Вставить("Ширина", Ширина);
	РазмерыРисунка.Вставить("Высота", Высота);
	
	ДопСвойства.Вставить("РазмерыРисунка", РазмерыРисунка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;

	// Вывод шапки отчета: заголовок и параметры
	СписокГруппировок = КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(КомпоновщикНастроек);
	Для каждого Группировка Из СписокГруппировок  Цикл
		Группировка.Значение.Использование = Ложь;
	КонецЦикла;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Продажи.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения", "АналитикаНоменклатуры.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("АналитикаНоменклатуры.Номенклатура.ЕдиницаИзмерения", "АналитикаНоменклатуры.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.Продажи.Запрос = ТекстЗапроса;	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	СписокГруппировок = КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(КомпоновщикНастроек);
	Для каждого Группировка Из СписокГруппировок  Цикл
		Группировка.Значение.Использование = Истина;
	КонецЦикла;
	
	// Подготовка таблицы с данными для вывода карты
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки, , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.ОтображатьПроцентВывода = Ложь;
	ТаблицаДанных = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаДанных);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	ВывестиСхему(ДокументРезультат, ТаблицаДанных);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВывестиСхему(ДокументРезультат, ТаблицаДанных)
	
	// Подготовим географическую схему
	Рисунок = ДокументРезультат.Рисунки.Добавить(ТипРисункаТабличногоДокумента.ГеографическаяСхема);
	Рисунок.Защита = Ложь;
	
	Рисунок.Верх = 50;
	
	// Настройка размеров рисунка
	Масштаб = 100;
	ПараметрМасштабКарты = Новый ПараметрКомпоновкиДанных("МасштабКарты");
	Для каждого ЭлементНастройки из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ЭлементНастройки.Параметр = ПараметрМасштабКарты Тогда
			Масштаб = ЭлементНастройки.Значение;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	КоэффМасштаба = Масштаб / 100;
	
	РазмерыРисунка = "";
	Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("РазмерыРисунка", РазмерыРисунка) Тогда
		Рисунок.Ширина = РазмерыРисунка.Ширина * КоэффМасштаба;
		Рисунок.Высота = РазмерыРисунка.Высота * КоэффМасштаба;
	Иначе
		Рисунок.Ширина = 400 * КоэффМасштаба;
		Рисунок.Высота = 240 * КоэффМасштаба;
	КонецЕсли;
	
	Схема = Рисунок.Объект;
	Схема.Очистить();
	Схема.Обновление = Ложь;
	
	СтруктураГеоСхемы = Константы.ГеографическаяСхемаДляОтчетов.Получить().Получить();
	Если СтруктураГеоСхемы = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Для формирования отчета необходимо выбрать карту в разделе администрирования ""CRM и продажи"".';
								|en = 'To generate a report, select a card in settings section CRM and Marketing.'");
	Иначе
		ГеоСхема = ""; НазваниеГеоСхемы = "";
		СтруктураГеоСхемы.Свойство("Название", НазваниеГеоСхемы);
		СтруктураГеоСхемы.Свойство("ГеоСхема", ГеоСхема);
		Схема.Вывести(ГеоСхема);
	КонецЕсли;
	
	Схема.ОтображатьЗаголовок = Истина;
	Схема.ОтображатьЛегенду = Истина;
	Схема.ОбластьЛегенды.МасштабнаяЛинейка = Ложь;
	
	Схема.ОбластьЗаголовка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, 0);
	Схема.ОбластьЗаголовка.Текст = НазваниеГеоСхемы;
	
	// Скроем видимость всех данных для всех слоев
	Для каждого Слой Из Схема.Слои Цикл
		Схема.УстановитьСвойствоОбъектов(Слой.Объекты, "ОтображатьДанные", Ложь);
	КонецЦикла;
	
	// Скроем все города, если они есть
	// Покажем столицы миллионники.
	СлойГорода = Схема.Слои.Найти("Столицы государств"); // СлойГеографическойСхемы
	Если СлойГорода = Неопределено Тогда
		СлойГорода = Схема.Слои.Найти("Столицы");
		Если СлойГорода = Неопределено Тогда
			СлойГорода = Схема.Слои.Найти("Города");
		КонецЕсли;
	КонецЕсли;
	
	Если СлойГорода <> Неопределено Тогда
		
		СтолицыМиллионнники = Новый Массив;
		СерияСтолица = СлойГорода.Серии.Найти("Столица"); // Столицы регионов России
		Если СерияСтолица <> Неопределено Тогда
			Столицы = СлойГорода.ВыбратьОбъекты(Новый Структура(СерияСтолица.Имя, Истина));
			СерияНаселение = СлойГорода.Серии.Найти("Население_95_Год");
			Если СерияНаселение <> Неопределено Тогда
				Для каждого Столица Из Столицы Цикл
					ЧисленностьНаселения = СлойГорода.ПолучитьЗначение(Столица, СерияНаселение);
					Если ЧисленностьНаселения.Значение >= 700 Тогда
						СтолицыМиллионнники.Добавить(Столица);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Иначе // Столицы государств
			СерияНаселение = СлойГорода.Серии.Найти("Разряд_Населения");
			Если СерияНаселение <> Неопределено Тогда
				Столицы10Миллионнники = СлойГорода.ВыбратьОбъекты(Новый Структура(СерияНаселение.Имя, 1));
				СтолицыМиллионнники = СлойГорода.ВыбратьОбъекты(Новый Структура(СерияНаселение.Имя, 2));
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СтолицыМиллионнники, Столицы10Миллионнники, Истина);
			КонецЕсли;
		КонецЕсли;
		
		Схема.УстановитьСвойствоОбъектов(СлойГорода.Объекты, "ТипОтрисовки", ТипОтображенияТочечногоОбъектаГеографическойСхемы.Символ);
		Схема.УстановитьСвойствоОбъектов(СлойГорода.Объекты, "Символ", "▪");
		
		// Названия городов
		СерияНазвание = СлойГорода.Серии.Найти("Название");
		Если СерияНазвание = Неопределено Тогда
			СерияНазвание = СлойГорода.Серии.Найти("Название_RU");
		КонецЕсли;
		
		Если СерияНазвание <> Неопределено Тогда
			СерияНазвание.ТипОтображения = ТипОтображенияСерииСлояГеографическойСхемы.Текст;
			СерияНазвание.ШрифтТекста = ШрифтыСтиля.ШрифтГеографическойКарты;
		КонецЕсли;
		
		Схема.УстановитьСвойствоОбъектов(СлойГорода.Объекты, "Видимость", Ложь);
		Схема.УстановитьСвойствоОбъектов(СтолицыМиллионнники, "Видимость", Истина);
		Схема.УстановитьСвойствоОбъектов(СтолицыМиллионнники, "ОтображатьДанные", Истина);
		
		СлойГорода.РазрешитьВыбор = Ложь;
		
	КонецЕсли;
	
	// Сброс раскраски регионов
	СлойРегионы = Схема.Слои[0];
	Схема.УстановитьСвойствоОбъектов(СлойРегионы.Объекты, "Цвет", Метаданные.ЭлементыСтиля.ЦветНеактивногоРегиона.Значение);
	
	// Определим, используется ли схема регионов с городами
	ВыбиратьГорода = Ложь;
	Если Схема.Слои.Найти("Регионы России") <> Неопределено
		И Схема.Слои.Найти("Города") <> Неопределено Тогда
		СлойГорода = Схема.Слои.Города;
		СлойГородаСерииСтолица = СлойГорода.Серии.Столица; // СерияДанныхСлояГеографическойСхемы
		НеСтолицы = СлойГорода.ВыбратьОбъекты(Новый Структура(СлойГородаСерииСтолица.Имя, Ложь));
		Если НеСтолицы.Количество() Тогда
			СерияКодРегиона = СлойГорода.Серии.Найти("КОД_КЛАДР_РЕГИОНА");
			Если СерияКодРегиона <> Неопределено Тогда
				ВыбиратьГорода = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Дополнить данные регионов данными городов
	Если ВыбиратьГорода Тогда
		ДополнитьТаблицуРегионовДаннымиГородов(СлойГорода, СерияКодРегиона, ТаблицаДанных);
	КонецЕсли;
	
	// Заполним схему данными
	Если ТаблицаДанных.Количество() Тогда
		ЗаполнитьСхему(Схема, ТаблицаДанных);
	КонецЕсли;
	
	Схема.Обновление = Истина;
	
КонецПроцедуры

// Параметры:
// 	Схема - ГеографическаяСхема - Обновляемая географическая схема
// 
Процедура ЗаполнитьСхему(Схема, ТаблицаДанных)
	
	Red = 0; Green = 0; Blue = 0;
	ПараметрВариантАнализа = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантАнализа");
	ПараметрВыделениеЛидеровАутсайдеров = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВыделениеЛидеровАутсайдеров");
	
	СлойРегионы = Схема.Слои[0]; // СлойГеографическойСхемы
	
	// Создадим в слое географической схемы серии для отображения данных
	СерияВыручка = СлойРегионы.Серии.Добавить("Выручка");
	СерияВыручка.ТипОтображения = ТипОтображенияСерииСлояГеографическойСхемы.НеОтображать;
	СерияВыручка.РежимОтображенияЗначений = РежимОтображенияЗначенийСерии.ОтображатьКакЗначение;
	СерияВыручка.Значение = "Выручка";
	СерияВыручка.Текст = "Выручка";
	СерияВыручка.ИмяГруппыСерий = "Продажи";
	СерияВыручка.Формат = "ЧДЦ=2";
	
	СерияВыручкаЗаПериодСравнения = СлойРегионы.Серии.Добавить("ВыручкаЗаПериодСравнения");
	СерияВыручкаЗаПериодСравнения.ТипОтображения = ТипОтображенияСерииСлояГеографическойСхемы.НеОтображать;
	СерияВыручкаЗаПериодСравнения.РежимОтображенияЗначений = РежимОтображенияЗначенийСерии.ОтображатьКакЗначение;
	СерияВыручкаЗаПериодСравнения.Значение = "ВыручкаПериодаСравнения";
	СерияВыручкаЗаПериодСравнения.Текст = НСтр("ru = 'Выручка за период сравнения';
												|en = 'Revenue for the comparison period'");
	СерияВыручкаЗаПериодСравнения.ИмяГруппыСерий = "Продажи";
	СерияВыручкаЗаПериодСравнения.Формат = "ЧДЦ=2";
	
	СерияИзменениеВыручки = СлойРегионы.Серии.Добавить("ИзменениеВыручки");
	СерияИзменениеВыручки.ТипОтображения = ТипОтображенияСерииСлояГеографическойСхемы.НеОтображать;
	СерияИзменениеВыручки.РежимОтображенияЗначений = РежимОтображенияЗначенийСерии.ОтображатьКакЗначение;
	СерияИзменениеВыручки.Значение = "ИзменениеВыручки";
	СерияИзменениеВыручки.Текст = НСтр("ru = 'Изменение выручки, %';
										|en = 'Change revenue, %'");
	СерияИзменениеВыручки.ИмяГруппыСерий = "Продажи";
	СерияИзменениеВыручки.Формат = "ЧДЦ=1";
	
	// Настройка легенды
	Если ПараметрВариантАнализа.Значение = 0 Тогда // Выручка за период отчета
		
		ТаблицаСумм = ТаблицаДанных.Скопировать(, "СуммаВыручкиТекущийПериод");
		СтрокиСНулевойСуммой = ТаблицаСумм.НайтиСтроки(Новый Структура("СуммаВыручкиТекущийПериод", 0));
		Для каждого УдаляемаяСтрока Из СтрокиСНулевойСуммой Цикл
			ТаблицаСумм.Удалить(УдаляемаяСтрока);
		КонецЦикла;
		ТаблицаСумм.Сортировать("СуммаВыручкиТекущийПериод");
		ТаблицаГраницИнтервалов = ПолучитьДиапазоныВыручки(ТаблицаСумм, 4);
		
		ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
		ЭлементЛегенды.Серия = СерияВыручка;
		ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'Выручка, руб.';
											|en = 'Revenue, rub.'");
		
		Если ТипЗнч(ТаблицаГраницИнтервалов) = Тип("ТаблицаЗначений") Тогда
			
			ДобавитьАбсолютныеКоэффициентыНасыщенности(ТаблицаДанных, ТаблицаГраницИнтервалов);
			
			ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
			ЭлементЛегенды.Серия = СерияВыручка;
			ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияВыручки1;
			ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'менее';
												|en = 'less'") + " " + Строка(ТаблицаГраницИнтервалов[0].Значение);
			
			КоличествоОтсечекИнтервалов = ТаблицаГраницИнтервалов.Количество();
			
			Для инд = 2 По КоличествоОтсечекИнтервалов Цикл
				ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
				ЭлементЛегенды.Серия = СерияВыручка;
				НазваниеКартинки = "ГрадацияВыручки" + инд;
				ЭлементЛегенды.Картинка = БиблиотекаКартинок[НазваниеКартинки];
				ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'от';
													|en = 'dated'") + " " + Строка(ТаблицаГраницИнтервалов[инд-2].Значение)
					 + " " + НСтр("ru = 'до';
									|en = 'to'") + " " + Строка(ТаблицаГраницИнтервалов[инд-1].Значение);
			КонецЦикла;
			
			Если КоличествоОтсечекИнтервалов >= 1 Тогда
				ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
				ЭлементЛегенды.Серия = СерияВыручка;
				НазваниеКартинки = "ГрадацияВыручки" + Строка(КоличествоОтсечекИнтервалов + 1);
				ЭлементЛегенды.Картинка = БиблиотекаКартинок[НазваниеКартинки];
				ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'более';
													|en = 'more'") + " " + Строка(ТаблицаГраницИнтервалов[КоличествоОтсечекИнтервалов-1].Значение);
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(ТаблицаГраницИнтервалов) = Тип("Число") Тогда // Есть всего одни регион
			
			ПустаяТаблица = Новый ТаблицаЗначений;
			ПустаяТаблица.Колонки.Добавить("Значение");
			
			ДобавитьАбсолютныеКоэффициентыНасыщенности(ТаблицаДанных, ПустаяТаблица);
			
			ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
			ЭлементЛегенды.Серия = СерияВыручка;
			ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияВыручки1;
			ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'равна';
												|en = 'equals to'") + " " + Строка(ТаблицаГраницИнтервалов);
			
		КонецЕсли;
		
	ИначеЕсли ПараметрВариантАнализа.Значение = 1 Тогда // Изменение выручки относительно предыдущего периода
		
		ДобавитьОтносительныеКоэффициентыНасыщенности(ТаблицаДанных, ПараметрВыделениеЛидеровАутсайдеров.Значение);
		
		СтрокаСреднийРост = Формат(ТаблицаДанных[0].СреднийРост, "ЧДЦ = 1");
		
		ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
		ЭлементЛегенды.Серия = СерияИзменениеВыручки;
		ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'Изменение выручки, %';
											|en = 'Change revenue, %'");
		
		Если ЗначениеЗаполнено(ПараметрВыделениеЛидеровАутсайдеров.Значение) Тогда
			ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
			ЭлементЛегенды.Серия = СерияИзменениеВыручки;
			ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияИзмененияВыручки4;
			ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'лидеры роста';
												|en = 'growth leaders'");
		КонецЕсли;
		
		ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
		ЭлементЛегенды.Серия = СерияИзменениеВыручки;
		ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияИзмененияВыручки5;
		ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'рост выше среднего (более';
											|en = 'above average growth (more'") + " " + СтрокаСреднийРост + " %)";
		
		ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
		ЭлементЛегенды.Серия = СерияИзменениеВыручки;
		ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияИзмененияВыручки3;
		ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'рост ниже среднего (до';
											|en = 'growth below average (until'") + " " + СтрокаСреднийРост + " %)";
		
		ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
		ЭлементЛегенды.Серия = СерияИзменениеВыручки;
		ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияИзмененияВыручки1;
		ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'падение';
											|en = 'decline'");
		
		Если ЗначениеЗаполнено(ПараметрВыделениеЛидеровАутсайдеров.Значение) Тогда
			ЭлементЛегенды = Схема.ОбластьЛегенды.Элементы.Добавить();
			ЭлементЛегенды.Серия = СерияИзменениеВыручки;
			ЭлементЛегенды.Картинка = БиблиотекаКартинок.ГрадацияИзмененияВыручки2;
			ЭлементЛегенды.ТекстПодписи = НСтр("ru = 'аутсайдеры по падению';
												|en = 'outsiders on drop'");
		КонецЕсли;
		
	КонецЕсли;
	
	// Вывод данных
	Для каждого ИтогПоРегиону Из ТаблицаДанных Цикл
		
		КодРегиона = ИтогПоРегиону.ЗначениеГеографическогоРегиона;
		Если ЗначениеЗаполнено(КодРегиона) Тогда
			
			Регион = СлойРегионы.НайтиПоЗначению(КодРегиона);
			
			Если Регион <> Неопределено Тогда
			
				Регион.Расшифровка = Новый Структура("БизнесРегион", ИтогПоРегиону.БизнесРегион);
		
				// Выделим регион
				Если ПараметрВариантАнализа.Значение = 0 Тогда
					
					Если ИтогПоРегиону.КоэффициентНасыщенности > 0 Тогда
						МониторингЦелевыхПоказателей.ПолучитьКрасныйЗеленыйСинийПоТонуНасыщенностиЯркости(
							220, // тон
							ИтогПоРегиону.КоэффициентНасыщенности, // насыщенность
							100, // яркость
							Red, Green, Blue);
						
						Регион.Цвет = Новый Цвет(Red, Green, Blue);
					КонецЕсли;
					
				ИначеЕсли ПараметрВариантАнализа.Значение = 1 Тогда // Изменение выручки относительно предыдущего периода
					
					Если ИтогПоРегиону.ЕстьПадение Тогда
						МониторингЦелевыхПоказателей.ПолучитьКрасныйЗеленыйСинийПоТонуНасыщенностиЯркости(0, ИтогПоРегиону.КоэффициентНасыщенности, 100, Red, Green, Blue);
						Регион.Цвет = Новый Цвет(Red, Green, Blue);
					ИначеЕсли ИтогПоРегиону.ЕстьРост Тогда
						МониторингЦелевыхПоказателей.ПолучитьКрасныйЗеленыйСинийПоТонуНасыщенностиЯркости(120, ИтогПоРегиону.КоэффициентНасыщенности, 100, Red, Green, Blue);
						Регион.Цвет = Новый Цвет(Red, Green, Blue);
					ИначеЕсли ИтогПоРегиону.ЕстьРостНижеСреднего Тогда
						МониторингЦелевыхПоказателей.ПолучитьКрасныйЗеленыйСинийПоТонуНасыщенностиЯркости(60, ИтогПоРегиону.КоэффициентНасыщенности, 100, Red, Green, Blue);
						Регион.Цвет = Новый Цвет(Red, Green, Blue);
					КонецЕсли;
					
				КонецЕсли;
				
				Регион.ОтображатьДанные = Истина;
				
				СлойРегионы.УстановитьЗначение(
					Регион,
					СерияВыручка,
					ИтогПоРегиону.СуммаВыручкиТекущийПериод,,);
					
				СлойРегионы.УстановитьЗначение(
					Регион,
					СерияВыручкаЗаПериодСравнения,
					ИтогПоРегиону.СуммаВыручкиПериодСравнения,,);
					
				СлойРегионы.УстановитьЗначение(
					Регион,
					СерияИзменениеВыручки,
					Окр(ИтогПоРегиону.ОтносительныйРостВыручки),,);
					
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьАбсолютныеКоэффициентыНасыщенности(ТаблицаЗначений, ТаблицаГраницИнтервалов)
	
	ТаблицаЗначений.Колонки.Добавить("КоэффициентНасыщенности");
	
	ТаблицаГраницИнтервалов.Сортировать("Значение Возр");
	КоличествоИнтервалов = ТаблицаГраницИнтервалов.Количество();
	ШагНасыщенности = 30; // Насыщенность цвета будем менять от 10 до 100, максимум 4 интервала
	
	Для каждого Значение Из ТаблицаЗначений Цикл
		Если Значение.СуммаВыручкиТекущийПериод = 0 Тогда
			Значение.КоэффициентНасыщенности = -1;
			Продолжить;
		КонецЕсли;
		Инт = 0;
		Для каждого Интервал Из ТаблицаГраницИнтервалов Цикл
			Если Значение.СуммаВыручкиТекущийПериод <= Интервал.Значение Тогда
				Значение.КоэффициентНасыщенности = 10 + Цел(ШагНасыщенности * Инт);
				Прервать;
			Иначе
				Инт = Инт + 1;
			КонецЕсли;
		КонецЦикла;
		Если Не ЗначениеЗаполнено(Значение.КоэффициентНасыщенности) Тогда
			Значение.КоэффициентНасыщенности = 10 + Цел(ШагНасыщенности * КоличествоИнтервалов);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОтносительныеКоэффициентыНасыщенности(ТаблицаЗначений, Топ)
	
	ТаблицаЗначений.Колонки.Добавить("КоэффициентНасыщенности");
	
	// Для относительных значений изменения выручки 5 областей: две градации падения, одна роста ниже среднего, две - роста
	// выше среднего.
	ТаблицаЗначений.Сортировать("Рост Убыв");
	РегионыРоста = ТаблицаЗначений.НайтиСтроки(Новый Структура("ЕстьРост", Истина));
	инд = 0;
	Для каждого РегионРоста Из РегионыРоста Цикл
		Если инд < Топ Тогда
			РегионРоста.КоэффициентНасыщенности = 100;
		Иначе
			РегионРоста.КоэффициентНасыщенности = 30;
		КонецЕсли;
		инд = инд + 1;
	КонецЦикла;
	
	РегионыРостаНижеСреднего = ТаблицаЗначений.НайтиСтроки(Новый Структура("ЕстьРостНижеСреднего", Истина));
	Для каждого РегионРостаНижеСреднего Из РегионыРостаНижеСреднего Цикл
		РегионРостаНижеСреднего.КоэффициентНасыщенности = 70;
	КонецЦикла;
	
	ТаблицаЗначений.Сортировать("Падение");
	РегионыПадения = ТаблицаЗначений.НайтиСтроки(Новый Структура("ЕстьПадение", Истина));
	инд = 0;
	Для каждого РегионПадения Из РегионыПадения Цикл
		Если инд < Топ Тогда
			РегионПадения.КоэффициентНасыщенности = 100;
		Иначе
			РегионПадения.КоэффициентНасыщенности = 30;
		КонецЕсли;
		инд = инд + 1;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДиапазоныВыручки(Данные, КоличествоДиапазонов)
	
	Если Не Данные.Количество() Тогда
		Возврат 0;
	КонецЕсли;
	
	КластерыВыручки = Новый АнализДанных;
	КластерыВыручки.ТипАнализа = Тип("АнализДанныхКластеризация");
	КластерыВыручки.ИсточникДанных = Данные;
	
	КластерыВыручки.Параметры.КоличествоКластеров.Значение = КоличествоДиапазонов;
	КластерыВыручки.Параметры.МетодКластеризации.Значение = МетодКластеризации.БлижняяСвязь;
	КластерыВыручки.Параметры.ТипЗаполненияТаблицы.Значение = ТипЗаполненияТаблицыРезультатаАнализаДанных.ВсеПоля;
	РезультатАнализа = КластерыВыручки.Выполнить();
	
	ЦентрыТяжестиКластеров = Новый ТаблицаЗначений;
	ЦентрыТяжестиКластеров.Колонки.Добавить("Значение");
	Для каждого Кластер Из РезультатАнализа.Кластеры Цикл
		ЦентрТяжестиКластера = ЦентрыТяжестиКластеров.Добавить();
		ЦентрТяжестиКластера.Значение = Кластер.ЦентрТяжести[0].Значение;
	КонецЦикла;
	ЦентрыТяжестиКластеров.Сортировать("Значение");
	
	КоличествоКластеров = РезультатАнализа.Кластеры.Количество();
	Если КоличествоКластеров = 1 Тогда
		Возврат ЦентрыТяжестиКластеров[0].Значение;
	КонецЕсли;
	
	ТаблицаГраницИнтервалов = Новый ТаблицаЗначений;
	ТаблицаГраницИнтервалов.Колонки.Добавить("Значение");

	Для инд = 0 По КоличествоКластеров - 2 Цикл
		ГраницаИнтервала = ТаблицаГраницИнтервалов.Добавить();
		СреднееРасстояниеМеждуИнтервалами = (ЦентрыТяжестиКластеров[инд + 1].Значение - ЦентрыТяжестиКластеров[инд].Значение)/2;
		ЧислоРазрядовДеления = СтрДлина(Формат(Окр(СреднееРасстояниеМеждуИнтервалами), "ЧГ=0"));
		ГраницаИнтервала.Значение = Окр(ЦентрыТяжестиКластеров[инд].Значение + СреднееРасстояниеМеждуИнтервалами, -ЧислоРазрядовДеления + 1);
	КонецЦикла;
	
	Возврат ТаблицаГраницИнтервалов;
	
КонецФункции

Процедура ДополнитьТаблицуРегионовДаннымиГородов(СлойГорода, СерияКодРегиона, ТаблицаДанных)
	
	// Результаты продаж в городах сложим в результаты регионов
	ТаблицаДанных.Колонки.Добавить("ЭтоРегион");
	ТаблицаДанных.ЗаполнитьЗначения(Истина, "ЭтоРегион");
	СоответствиеРегионыДляПересчета = Новый Соответствие;
	Для каждого СтрокаГорода Из ТаблицаДанных Цикл
		КодГорода = СтрокаГорода.ЗначениеГеографическогоРегиона;
		Если ЗначениеЗаполнено(КодГорода) Тогда
			Город = СлойГорода.НайтиПоЗначению(КодГорода);
			Если Город <> Неопределено Тогда
				КодРегиона = СлойГорода.ПолучитьЗначение(Город, СерияКодРегиона);
				СтрокаРегиона = ТаблицаДанных.Найти(КодРегиона.Значение, "ЗначениеГеографическогоРегиона");
				Если СтрокаРегиона = Неопределено Тогда
					СтрокаРегиона = ТаблицаДанных.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаРегиона, СтрокаГорода);
					СтрокаРегиона.ЗначениеГеографическогоРегиона = КодРегиона.Значение;
				Иначе
					СтрокаРегиона.СуммаВыручкиТекущийПериод = СтрокаРегиона.СуммаВыручкиТекущийПериод + СтрокаГорода.СуммаВыручкиТекущийПериод;
					СтрокаРегиона.СуммаВыручкиПериодСравнения = СтрокаРегиона.СуммаВыручкиПериодСравнения + СтрокаГорода.СуммаВыручкиПериодСравнения;
				КонецЕсли;
				СтрокаГорода.ЭтоРегион = Ложь;
				Если СоответствиеРегионыДляПересчета.Получить(КодРегиона.Значение) = Неопределено Тогда
					СоответствиеРегионыДляПересчета.Вставить(КодРегиона.Значение, СтрокаРегиона);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	// Пересчет относительных показателей
	Для каждого СтрокаРегиона Из СоответствиеРегионыДляПересчета Цикл
		СтрокаТаблицы = СтрокаРегиона.Значение;
		Если СтрокаТаблицы.СуммаВыручкиПериодСравнения = 0 Тогда
			СтрокаТаблицы.ОтносительныйРостВыручки = 100;
		Иначе
			СтрокаТаблицы.ОтносительныйРостВыручки = (СтрокаТаблицы.СуммаВыручкиТекущийПериод / СтрокаТаблицы.СуммаВыручкиПериодСравнения - 1) * 100;
		КонецЕсли;
		СтрокаТаблицы.Рост = ?(СтрокаТаблицы.ОтносительныйРостВыручки > СтрокаТаблицы.СреднийРост, СтрокаТаблицы.ОтносительныйРостВыручки, 0);
		СтрокаТаблицы.ЕстьРост = СтрокаТаблицы.Рост <> 0;
		СтрокаТаблицы.РостНижеСреднего = ?(СтрокаТаблицы.ОтносительныйРостВыручки > 0
			И СтрокаТаблицы.ОтносительныйРостВыручки <= СтрокаТаблицы.СреднийРост, СтрокаТаблицы.ОтносительныйРостВыручки, 0);
		СтрокаТаблицы.ЕстьРостНижеСреднего = СтрокаТаблицы.РостНижеСреднего <> 0;
		СтрокаТаблицы.Падение = ?(СтрокаТаблицы.ОтносительныйРостВыручки < 0, СтрокаТаблицы.ОтносительныйРостВыручки, 0);
		СтрокаТаблицы.ЕстьПадение = СтрокаТаблицы.Падение <> 0;
	КонецЦикла;
	ТаблицаДанных = ТаблицаДанных.Скопировать(Новый Структура("ЭтоРегион", Истина));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли